Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1GVSzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:55:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:39415 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab1GVSzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:55:42 -0400
From: Richard Weinberger <richard@nod.at>
To: JBeulich@novell.com
Subject: Re: linux-next: Tree for July 22 (uml)
Date: Fri, 22 Jul 2011 20:55:34 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au> <20110722085346.51565411.rdunlap@xenotime.net>
In-Reply-To: <20110722085346.51565411.rdunlap@xenotime.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, mingo@elte.hu,
        akpm@linux-foundation.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201107222055.35341.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 22 Juli 2011, 17:53:46 schrieben Sie:
> On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:
> > Hi all,
> 
> uml build on i386 fails with:
> 
> arch/um/sys-i386/built-in.o: In function `call_rwsem_down_read_failed':
> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:93: undefined
> reference to `rwsem_down_read_failed' arch/um/sys-i386/built-in.o: In
> function `call_rwsem_down_write_failed':
> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:105: undefined
> reference to `rwsem_down_write_failed' arch/um/sys-i386/built-in.o: In
> function `call_rwsem_wake':
> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:118: undefined
> reference to `rwsem_wake' arch/um/sys-i386/built-in.o: In function
> `call_rwsem_downgrade_wake':
> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:130: undefined
> reference to `rwsem_downgrade_wake'
> 

Jan,

"x86: Unify rwsem assembly implementation" broke the UML build on i386.
Please compile test you changes or CC me when you are touch something in arch/um/.

make ARCH=um SUBARCH=i386
and
make ARCH=um SUBARCH=x86_64

does not hurt. :-)

Thanks,
//richard

---

>From b9ec24beb55276d74fdf4f9f9607c69fc8662b72 Mon Sep 17 00:00:00 2001
From: Richard Weinberger <richard@nod.at>
Date: Fri, 22 Jul 2011 20:46:32 +0200
Subject: [PATCH] um: Make rwsem.S depend on CONFIG_RWSEM_XCHGADD_ALGORITHM

rwsem.S can only be used with CONFIG_RWSEM_XCHGADD_ALGORITHM.
This unbreaks the UML build on i386.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/um/sys-i386/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 15587ed..87b659d 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -8,7 +8,8 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/rwsem.o lib/string_32.o
+subarch-obj-y = lib/string_32.o
+subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
-- 
1.7.6

