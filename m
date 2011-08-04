Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1HDT5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 15:57:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:54286 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1HDT5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 15:57:23 -0400
Date: Thu, 4 Aug 2011 15:55:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: linux-next: Tree for July 25 (xen)
Message-ID: <20110804195539.GA11198@dumpdata.com>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
 <20110725144629.b752bf14.rdunlap@xenotime.net>
 <20110804193534.GB12729@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110804193534.GB12729@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E3AF94B.0042,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 09:35:34PM +0200, Ingo Molnar wrote:
> 
> * Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > On Mon, 25 Jul 2011 16:25:42 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > 
> > xen has lots of build errors and warnings (all on x86_64).

Hm, I have a fix in my linux-next (and stable/bug.fixes) for this that I was thinking
to send in a couple of days ..


commit 1e9ea2656b656edd3c8de98675bbc0340211b5bd
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed Aug 3 09:43:44 2011 -0700

     xen/tracing: it looks like we wanted CONFIG_FTRACE
    
    Apparently we wanted CONFIG_FTRACE rather the CONFIG_FUNCTION_TRACER.
    
    Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
    Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 45e94ac..3326204 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -15,7 +15,7 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			grant-table.o suspend.o platform-pci-unplug.o \
 			p2m.o
 
-obj-$(CONFIG_FUNCTION_TRACER) += trace.o
+obj-$(CONFIG_FTRACE) += trace.o
 
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o

.. snip of the long compile error..

> These build failures are still triggering upstream:
> 
>  arch/x86/xen/trace.c:44:2: error: array index in initializer not of integer type
>  arch/x86/xen/trace.c:44:2: error: (near initialization for ‘xen_hypercall_names’)
>  arch/x86/xen/trace.c:45:1: error: ‘__HYPERVISOR_arch_4’ undeclared here (not in a function)
>  arch/x86/xen/trace.c:45:2: error: array index in initializer not of integer type
>  arch/x86/xen/trace.c:45:2: error: (near initialization for ‘xen_hypercall_names’)

Oh, that I haven't seen. Can you send me the .config for that please.

> 
> even after:
> 
>  b3c4b9825075: xen/tracing: fix compile errors when tracing is disabled.
> 
> Btw., that the heck is going on with the commit that introduced the 
> build failure:
> 
>  commit bd9ddc875b6659f9f74dcfd285c472bc58041abd
>  Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>  AuthorDate: Mon Jun 20 17:52:13 2011 -0700
>  Commit:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>  CommitDate: Mon Jul 18 15:43:46 2011 -0700
> 
> It was apparently rebased shortly before the merge window and sent to 

Well, the rebase I get - it was done on top of the merge that introduced
the new functionality.

> Linus 3 days later, with little to no linux-next testing ...

<Hmm> It did fix the compile problem.. albeit it created another one.
> 
> I'm absolutely unhappy about how the Xen tree is being run. It's 
> using a sloppy, crappy workflow and it is producing crap.

Do you have a manual of how you guys run your workflow?
