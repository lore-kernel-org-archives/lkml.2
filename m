Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab1B0FmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 00:42:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48691 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810Ab1B0FmA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 00:42:00 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 27 Feb 2011 05:41:35 +0000
Message-ID: <1298785295.3069.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] mm: <asm-generic/pgtable.h> must include <linux/mm_types.h>
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e2cda322648122dc400c85ada80eaddbc612ef6a 'thp: add pmd mangling
generic functions' replaced some macros in <asm-generic/pgtable.h>
with inline functions.  If the functions are to be defined (not all
architectures need them) then struct vm_area_struct must be defined
first.  So include <linux/mm_types.h>.

Fixes a build failure seen in Debian:

  CC [M]  drivers/media/dvb/mantis/mantis_pci.o
In file included from /build/buildd-linux-2.6_2.6.38~rc6-1~experimental.1-armel-6J2ga4/linux-2.6-2.6.38~rc6/debian/build/source_armel_none/arch/arm/include/asm/pgtable.h:460,
                 from /build/buildd-linux-2.6_2.6.38~rc6-1~experimental.1-armel-6J2ga4/linux-2.6-2.6.38~rc6/debian/build/source_armel_none/drivers/media/dvb/mantis/mantis_pci.c:25:
/build/buildd-linux-2.6_2.6.38~rc6-1~experimental.1-armel-6J2ga4/linux-2.6-2.6.38~rc6/debian/build/source_armel_none/include/asm-generic/pgtable.h: In function 'ptep_test_and_clear_young':
/build/buildd-linux-2.6_2.6.38~rc6-1~experimental.1-armel-6J2ga4/linux-2.6-2.6.38~rc6/debian/build/source_armel_none/include/asm-generic/pgtable.h:29: error: dereferencing pointer to incomplete type

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/asm-generic/pgtable.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 31b6188..b4bfe33 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -4,6 +4,8 @@
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_MMU
 
+#include <linux/mm_types.h>
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
-- 
1.7.4.1


