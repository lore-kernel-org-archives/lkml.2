Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1JKJHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:07:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:39258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1JKJHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:07:18 -0400
Subject: Re: sched: ARM: arch_scale_freq_power
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
In-Reply-To: <CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	 <CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	 <1318319852.14400.65.camel@laptop>
	 <CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 11:13:19 +0200
Message-ID: <1318324399.14400.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 10:51 +0200, Vincent Guittot wrote:
> I have several goals. The 1st one is that I need to put more load on
> some cpus when I have packages with different cpu frequency.

That should be rather easy.

> I also study if I can follow the real cpu frequency but it seems to be
> not so easy.

Why not?

>  I have noticed that the cpu_power is updated periodical
> except when we have a lot of newly_idle events.

We can certainly fix that.

> Then, I have some use cases which have several running tasks but a low
> cpu load. In this case, the small tasks are spread on several cpu by
> the load_balance whereas they could be easily handled by one cpu
> without significant performance modification. 

That shouldn't be done using cpu_power, we have sched_smt_power_savings
and sched_mc_power_savings for stuff like that.

Although I would really like to kill all those different
sched_*_power_savings knobs and reduce it to one.

> If the cpu_power is
> higher than 1024, the cpu is no more seen out of capacity by the
> load_balance as soon as a short process is running and teh main result
> is that the small tasks will stay on the same cpu. This configuration
> is mainly usefull for ARM dual core system when we want to power gate
> one cpu. I use cyclictest to simulate such use case. 

Yeah, but that's wrong.

