Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309Ab1D0XxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:53:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab1D0XxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Ad2DUQ2Lr-Q5Y+eYxKMyz04fL2g@mail.gmail.com>
References: <20110425214933.GO2468@linux.vnet.ibm.com> <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home> <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos> <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home> <alpine.LFD.2.02.1104272351290.3323@ionos>
 <20110427222727.GU2135@linux.vnet.ibm.com> <alpine.LFD.2.02.1104280028250.3323@ionos>
 <BANLkTi=Ad2DUQ2Lr-Q5Y+eYxKMyz04fL2g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Apr 2011 16:46:16 -0700
Message-ID: <BANLkTikknBQeSi0w7LeUTwSiMed-6LNKBw@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> We _know_ it didn't run continuously for 950ms. That number is totally
> made up. There's not enough work for it to run that long, but more
> importantly, the thread has zero CPU time. There is _zero_ reason to
> believe that it runs for long periods.

Hmm. But it might certainly have run for a _total_ of 950ms. Since
that's just under a second, we wouldn't see it in the "ps" output.

Where is rt_time cleared? I see that subtract in
do_sched_rt_period_timer(), but judging by the caller that is only
called for some timer overrun case (I didn't look at what the
definition of such an overrun is, though). Shouldn't rt_time be
cleared when the task goes to sleep voluntarily?

What am I missing?

                   Linus
