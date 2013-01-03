Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3ACMcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:32:46 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53149 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3ACMco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:32:44 -0500
MIME-Version: 1.0
Date: Thu, 3 Jan 2013 13:32:43 +0100
Message-ID: <CAHTX3d+P_UQK8nPfN8BKLdTkVY2VMKhty1rkCKbfHCrQBa+Nyw@mail.gmail.com>
Subject: Add #includes needed to permit the removal of asm/system.h - sha1 96f951edb1f1bdbbc99b0cd458f9808bb83d58ae
From: Michal Simek <monstr@monstr.eu>
To: dhowells@redhat.com, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI David and Arnd,

This patch is breaking microblaze kernel compilation

commit 96f951edb1f1bdbbc99b0cd458f9808bb83d58ae
Author: David Howells <dhowells@redhat.com>
Date:   Wed Mar 28 18:30:03 2012 +0100

    Add #includes needed to permit the removal of asm/system.h

Warning log:
  CC      kernel/irq_work.o
In file included from include/linux/irq_work.h:4,
                 from kernel/irq_work.c:11:
include/linux/llist.h: In function 'llist_add':
include/linux/llist.h:185: error: implicit declaration of function
'cmpxchg_local'
include/linux/llist.h:185: warning: assignment makes pointer from
integer without a cast
make[1]: *** [kernel/irq_work.o] Error 1
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....


It is because microblaze uses cmpxchg_local which is defined
asm-generic/atomic.h file.
Arnds patch has added it to atomic.h
asm-generic: add generic atomic.h and io.h
(sha1: 3f7e212df82ca0459d44c91d9e019efd1b5f936c)

What about to move cmpxchg_local and cmpxchg64_local from atomic.h to
cmpxchg-local.h?

If this should be separate step after your patch then please squash
the patch below to your one.

Thanks,
Michal

diff --git a/arch/microblaze/include/asm/cmpxchg.h
b/arch/microblaze/include/asm/cmpxchg.h
index 538afc0..cd10925 100644
--- a/arch/microblaze/include/asm/cmpxchg.h
+++ b/arch/microblaze/include/asm/cmpxchg.h
@@ -38,5 +38,6 @@ static inline unsigned long __xchg(unsigned long x,
volatile void *ptr,

 #include <asm-generic/cmpxchg.h>
 #include <asm-generic/cmpxchg-local.h>
+#include <asm-generic/atomic.h>

 #endif /* _ASM_MICROBLAZE_CMPXCHG_H */


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
