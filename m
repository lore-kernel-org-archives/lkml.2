Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1D1TXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:23:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33306 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754066Ab1D1TW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:22:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18XwM1UZGAXkPzfG9PZREpUX2WNm3erN7XDn1XGyK
	nef3cgZGyJfE0X
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
From: Mike Galbraith <efault@gmx.de>
To: sedat.dilek@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
In-Reply-To: <BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com>
References: <20110426112756.GF4308@linux.vnet.ibm.com>
	 <20110426183859.6ff6279b@neptune.home>
	 <20110426190918.01660ccf@neptune.home>
	 <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
	 <alpine.LFD.2.02.1104262314110.3323@ionos>
	 <20110427081501.5ba28155@pluto.restena.lu>
	 <20110427204139.1b0ea23b@neptune.home>
	 <alpine.LFD.2.02.1104272351290.3323@ionos>
	 <alpine.LFD.2.02.1104281051090.19095@ionos>
	 <BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com>
	 <20110428102609.GJ2135@linux.vnet.ibm.com>
	 <1303997401.7819.5.camel@marge.simson.net>
	 <BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 21:22:42 +0200
Message-ID: <1304018562.7462.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 17:28 +0200, Sedat Dilek wrote:

> OK, I tried with the patch proposed by Thomas (0003):

(thanks)

> patches/0001-Revert-rcu-restrict-TREE_RCU-to-SMP-builds-with-PREE.patch
> patches/0002-sched-Add-warning-when-RT-throttling-is-activated.patch
> patches/0003-sched-Remove-skip_clock_update-check.patch
> 
> >From the very beginning it looked as the system is "stable" due to:
> 
>   .rt_nr_running                 : 0
>   .rt_throttled                  : 0
> 
> This changed when I started a simple tar-job to save my kernel
> build-dir to an external USB-hdd.
> From...
> 
>   .rt_nr_running                 : 1
>   .rt_throttled                  : 1
> 
> ...To:
> 
>   .rt_nr_running                 : 2
>   .rt_throttled                  : 1
> 
> Unfortunately, reducing all activities to a minimum load, did not
> change from last known RT throttling state.
> 
> Just noticed rt_time exceeds the value of 950 first time here:

That would happen even if we did forced eviction.

> ----------------------------------------------------------------------------------------------------------
> R            cat  2652    115108.993460         1   120
> 115108.993460         1.147986         0.000000 /
> --
> rt_rq[0]:
>   .rt_nr_running                 : 1
>   .rt_throttled                  : 1
>   .rt_time                       : 950.005460
>   .rt_runtime                    : 950.000000
> ----------------------------------------------------------------------------------------------------------
>            rcuc0     7         0.000000     56869    98
> 0.000000       981.385605         0.000000 /
> --
> rt_rq[0]:
>   .rt_nr_running                 : 2
>   .rt_throttled                  : 1
>   .rt_time                       : 950.005460
>   .rt_runtime                    : 950.000000

Still getting stuck.  Eliminates the clock update optimization, but that
seemed unlikely anyway.  (I'll build a UP kernel and poke it)

	-Mike

