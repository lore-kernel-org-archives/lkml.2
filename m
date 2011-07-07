Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1GGTrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:47:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36090 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1GGTrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:47:20 -0400
From: julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Date: Thu, 7 Jul 2011 20:47:13 +0100
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4-revert+; KDE/4.6.2; x86_64; ; )
Cc: julie Sullivan <kernelmail.jms@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, torvalds@linux-foundation.org
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com> <20110706212348.GO6014@linux.vnet.ibm.com>
In-Reply-To: <20110706212348.GO6014@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072047.14429.kernelmail.jms@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011 22:23:48 Paul E. McKenney wrote:
> On Wed, Jul 06, 2011 at 10:10:16PM +0100, julie Sullivan wrote:
> > None of my kernels after 3.0-rc3 will boot on my Dell XPS-M1730
> > (x86-64 2-core) test box running
> > Ubuntu (Kubuntu) 11.04 (i.e. the first unbootable one was -rc4).
> > The machine freezes immediately after selecting the kernel from the
> > bootloader menu, leaving
> > me with a blank blue screen so I can't give you any log messages.
> > 
> > It bisects to the following commit:
> > 
> > commit a46e0899eec7a3069bcadd45dfba7bf67c6ed016
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Wed Jun 15 15:47:09 2011 -0700
> > 
> >     rcu: use softirq instead of kthreads except when RCU_BOOST=y
> >     
> >     This patch #ifdefs RCU kthreads out of the kernel unless RCU_BOOST=y,
> >     thus eliminating context-switch overhead if RCU priority boosting has
> >     not been configured.
> >     
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> 
> Hello, Julie,
> 
> One approach would be to cherry-pick the following commits:
>
> f8b7fc6b514f34a51875dd48dff70d4d17a54f38 rcu: Move RCU_BOOST #ifdefs to header f
> a46e0899eec7a3069bcadd45dfba7bf67c6ed016 rcu: use softirq instead of kthreads ex
> 09223371deac67d08ca0b70bd18787920284c967 rcu: Use softirq to address performance
> 9a432736904d386cda28b987b38ba14dae960ecc rcu: Simplify curing of load woes

> 
> Another approach would be to move ahead to v3.0-rc4 or later.
> 
> 							Thanx, Paul

Hi Paul
Thanks for your prompt reply, sorry for the delay in mine (real life intervened :-)
I tried reverting those 4 commits on v3.0-rc4 and can confirm that it _does_ give me a bootable 3.0-rc4 kernel.
I'll do some more testing. If you would like me to try anything specific just let me know :-)

Cheers
Julie
