Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab1D1K0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:26:38 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47969 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937Ab1D1K00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:26:26 -0400
Date: Thu, 28 Apr 2011 03:26:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110428102609.GJ2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:45:03AM +0200, Sedat Dilek wrote:
> Hi,
> 
> not sure if my problem from linux-2.6-rcu.git#sedat.2011.04.23a is
> related to the issue here.
> 
> Just FYI:
> I am here on a Pentium-M (uniprocessor aka UP) and still unsure if I
> have the correct (optimal?) kernel-configs set.
> 
> Paul gave me a script to collect RCU data and I enhanced it with
> collecting SCHED data.
> 
> In the above mentionned GIT branch I applied these two extra commits
> (0001 requested by Paul and 0002 proposed by Thomas):
> 
> patches/0001-Revert-rcu-restrict-TREE_RCU-to-SMP-builds-with-PREE.patch
> patches/0002-sched-Add-warning-when-RT-throttling-is-activated.patch
> 
> Furthermore, I have added my kernel-config file, scripts, patches and
> logs (also output of 'cat /proc/cpuinfo').
> 
> Hope this helps the experts to narrow down the problem.

Yow!!!

Now this one might well be able to hit the 950 millisecond limit.
There are no fewer than 1,314,958 RCU callbacks queued up at the end of
the test.  And RCU has indeed noticed this and cranked up the number
of callbacks to be handled by each invocation of rcu_do_batch() to
2,147,483,647.  And only 15 seconds earlier, there were zero callbacks
queued and the rcu_do_batch() limit was at the default of 10 callbacks
per invocation.

							Thanx, Paul

> Regards,
> - Sedat -
> 
> P.S.: I adapted the patch from [1] against
> linux-2.6-rcu.git#sedat.2011.04.23a, but did not help here.
> 
> [1] http://lkml.org/lkml/2011/4/22/35



