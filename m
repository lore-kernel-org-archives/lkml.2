Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1G1Tg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 15:36:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:57868 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1G1Tgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 15:36:55 -0400
Date: Thu, 28 Jul 2011 21:36:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt4
In-Reply-To: <4E31B59F.1000607@localhost>
Message-ID: <alpine.LFD.2.02.1107282123380.2660@ionos>
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <4E31B59F.1000607@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Fernando Lopez-Lezcano wrote:

> On 07/27/2011 02:37 PM, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt4 release.
> 
> Testing rt5 (lenovo dual core laptop running fc15, kernel based on koji's
> 3.0.0 build plus rt5)...
> ----
> [    0.000000] =============================================
> [    0.000000] [ INFO: possible recursive locking detected ]
> [    0.000000] 3.0.0-1.rt5.1.fc15.ccrma.i686.rtPAE #1
> [    0.000000] ---------------------------------------------
> [    0.000000] swapper/0 is trying to acquire lock:
> [    0.000000]  (&parent->list_lock){+.+...}, at: [<c04fb406>]
> __cache_free+0x43/0xc3
> [    0.000000]
> [    0.000000] but task is already holding lock:
> [    0.000000]  (&parent->list_lock){+.+...}, at: [<c04fc538>]
> do_tune_cpucache+0xf2/0x2bb
> [    0.000000]
> [    0.000000] other info that might help us debug this:
> [    0.000000]  Possible unsafe locking scenario:
> [    0.000000]
> [    0.000000]        CPU0
> [    0.000000]        ----
> [    0.000000]   lock(&parent->list_lock);
> [    0.000000]   lock(&parent->list_lock);

That's a know issue. Fix is being worked on. I can't find the thread
right now, but it's weird some interaction of debug options
(DEBUG_OBJECTS, DEBUG_SLAB ...) Peter ???
 
> (I guess because HIGHMEM is disabled the computer only finds 800M+ of LOWMEM
> and that is all top reports - total installed is 4G)

Yes, that's the state for now until someone fixes it :)

Thanks,

	tglx
