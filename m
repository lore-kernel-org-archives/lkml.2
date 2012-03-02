Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2CBVR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:17:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2CBVR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:17:58 -0500
Date: Fri, 2 Mar 2012 13:17:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: ODEBUG: selftest warnings failed 4 != 5 (WARNING: at
 lib/debugobjects.c:908 check_results.constprop.9)
Message-Id: <20120302131756.32e7f788.akpm@linux-foundation.org>
In-Reply-To: <CAFLxGvy0yWe2utG-+vFw4BhfH-i0vfjNy3k6kUsxkN7M4BSWQg@mail.gmail.com>
References: <20120218023521.GB13538@smp.if.uj.edu.pl>
	<CAFLxGvy0yWe2utG-+vFw4BhfH-i0vfjNy3k6kUsxkN7M4BSWQg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 00:18:37 +0100
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> On Sat, Feb 18, 2012 at 3:35 AM, Witold Baryluk
> <baryluk@smp.if.uj.edu.pl> wrote:
> > Hello everybody,
> >
> > I recently enabled a CONFIG_DEBUG_OBJECTS kconfig option, and this is what I got when booting
> >
> > ...
> > [ __ __0.000000] Linux version 3.3.0-rc3-t43-devel-smp-00278-g4903062-dirty (baryluk@sredniczarny) (gcc version 4.6.2 (Debian 4.6.2-14) ) #27 SMP Fri Feb 17 20:13:29 CE
> > ...
> > ...
> > ...
> > [ __ __0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> > [ __ __0.000000] Hierarchical RCU implementation.
> > [ __ __0.000000] __RCU debugfs-based tracing is enabled.
> > [ __ __0.000000] __RCU lockdep checking is enabled.
> > [ __ __0.000000] NR_IRQS:2304 nr_irqs:256 16
> > [ __ __0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
> > [ __ __0.000000] Extended CMOS year: 2000
> > [ __ __0.000000] Console: colour VGA+ 80x25
> > [ __ __0.000000] console [tty0] enabled
> > [ __ __0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> > [ __ __0.000000] ... MAX_LOCKDEP_SUBCLASSES: __8
> > [ __ __0.000000] ... MAX_LOCK_DEPTH: __ __ __ __ __48
> > [ __ __0.000000] ... MAX_LOCKDEP_KEYS: __ __ __ __8191
> > [ __ __0.000000] ... CLASSHASH_SIZE: __ __ __ __ __4096
> > [ __ __0.000000] ... MAX_LOCKDEP_ENTRIES: __ __ 16384
> > [ __ __0.000000] ... MAX_LOCKDEP_CHAINS: __ __ __32768
> > [ __ __0.000000] ... CHAINHASH_SIZE: __ __ __ __ __16384
> > [ __ __0.000000] __memory used by lock dependency info: 3823 kB
> > [ __ __0.000000] __per task-struct memory footprint: 1920 bytes
> > [ __ __0.000000] ------------------------
> > [ __ __0.000000] | Locking API testsuite:
> > ...
> > ...
> > [ __ __0.000000] -------------------------------------------------------
> > [ __ __0.000000] Good, all 218 testcases passed! |
> > [ __ __0.000000] ---------------------------------
> > [ __ __0.000000] ODEBUG: 14 of 14 active objects replaced
> > [ __ __0.000000] ------------[ cut here ]------------
> > [ __ __0.000000] WARNING: at lib/debugobjects.c:908 check_results.constprop.9+0x11c/0x140()
> > [ __ __0.000000] Hardware name: 2669UYD
> > [ __ __0.000000] ODEBUG: selftest warnings failed 4 != 5
> 
> This warning is still present.
> Andrew?

Dunno, sorry.  There are only two patches to bisect through - try
reverting b84d435cc228e ("debugobjects: Extend to assert that an object
is initialized") and then feac18dda25134 ("debugobjects: Be smarter
about static objects")?  
