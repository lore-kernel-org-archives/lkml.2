Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1JKQVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:21:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:44771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1JKQVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:21:42 -0400
Subject: Re: sched: ARM: arch_scale_freq_power
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>
Date: Tue, 11 Oct 2011 18:21:15 +0200
In-Reply-To: <CAKfTPtDgKcTucAR-YW27boAeUu1Ur6Txw6hLm3B48jw+sgEUOw@mail.gmail.com>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	 <CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	 <1318319852.14400.65.camel@laptop>
	 <CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
	 <1318324399.14400.71.camel@laptop>
	 <CAKfTPtDzY4pORvWd3Qa6kqpNsspKN7iEskQ+7F5D=mAwQWoKNg@mail.gmail.com>
	 <1318328848.8395.45.camel@twins>
	 <CAKfTPtDgKcTucAR-YW27boAeUu1Ur6Txw6hLm3B48jw+sgEUOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318350075.14615.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 18:03 +0200, Vincent Guittot wrote:
> > How do you know the task is 'small' ?
> >
> 
> I want to use cpufreq to be notified that we have a large/small cpu
> load. If we have several tasks but the cpu uses the lowest frequency,
> it "should" mean that we have small tasks that are running (less than
> 20ms*95% of added duration) and we could gather them on one cpu (by
> increasing the cpu_power on a dual core).
> 
> > For that you would need to track a time-weighted effective load average
> > of the task and we don't have that.
> >
> 
> yes, that's why I use cpufreq until better option, like a
> time-weighted load average, is available 

Egads... so basically you're (ab)using the ondemand cpufreq stats to get
a guestimate of the time-weighted load of the cpu, and then (ab)use the
scheduler cpufreq hook to pump its capacity numbers.

No cookies for you.
