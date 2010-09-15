Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0IOHwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 03:52:18 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:53718 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab0IOHwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 03:52:16 -0400
Date: Wed, 15 Sep 2010 09:51:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
Message-ID: <20100915095157.0acfba6d@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
	<20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
	<1284377790.2275.212.camel@laptop>
	<1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 13:29:50 +0800
Huang Ying <ying.huang@intel.com> wrote:

> On Mon, 2010-09-13 at 19:36 +0800, Peter Zijlstra wrote:
> > On Mon, 2010-09-13 at 12:32 +0200, Martin Schwidefsky wrote:
> > > On Mon, 13 Sep 2010 14:50:48 +0800
> > > Huang Ying <ying.huang@intel.com> wrote:
> > > 
> > > > From:  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > 
> > > > In order for other NMI context users that want to run things from
> > > > hard-IRQ context, extract the perf_event callback mechanism.
> > > > 
> > > > Huang Ying: some fixes
> > > > 
> > > > This patch is only tested on x86 platform.
> > > > 
> > > > 
> > > > v4:
> > > > 
> > > > -rebased on latest -tip tree
> > > > 
> > > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > 
> > > On s390 I get compile errors:
> > > 
> > > include/linux/perf_event.h:464:29: error: asm/perf_event.h: No such file or directory
> > > 
> > > Not a good idea to completely remove the perf_event.h from arch/s390/include/asm.
> > > With an empty header file the kernel at least compiles.
> > 
> > Urgh, Huang, could you at least compile test the other arches?
> 
> I uses the cross build tool from:
> 
> http://www.kernel.org/pub/tools/crosstool/
> 
> But I get compile errors on s390 and alpha even for tip/master
> (ce0c65112d37ff04016b4e0962a406281640739b). The build logs are attached.
> 
> Do I use the wrong git tree? Or we should fix tip/master firstly?
> 
> And frv and sh have compile error even for linus/master and 2.6.35. So I
> can not compile test for these arches.
> 
> Do I use the wrong cross tool?
> 
> The kernel configuration is generated as follow:
> 
> make defconfig
> ./scripts/config --enable perf_events

The compile error on s390 is a known problem in the -tip/-next tree introduced
with git commit 2bf2160d8805de64308e2e7c3cd97813cb58ed2f. The proposed solution
from Heiko as discussed on linux-next is this patch:

---
 arch/s390/include/asm/hardirq.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/s390/include/asm/hardirq.h
+++ b/arch/s390/include/asm/hardirq.h
@@ -12,10 +12,6 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/sched.h>
-#include <linux/cache.h>
-#include <linux/interrupt.h>
 #include <asm/lowcore.h>
 
 #define local_softirq_pending() (S390_lowcore.softirq_pending)


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

