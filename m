Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1DPQvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:51:49 -0400
Received: from [69.28.251.93] ([69.28.251.93]:57442 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab1DPQv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:51:26 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] MIPS: Remove unused PAGE_* definitions
Date: Sat, 16 Apr 2011 09:44:32 -0700
Message-Id: <ac7d470d5c334dc7870fa13d71942d21@localhost>
In-Reply-To: <7aa38c32b7748a95e814e5bb0583f967@localhost>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAGE_{NONE,READONLY,COPY,SHARED} are no longer needed after refactoring
setup_protection_map() to explicitly list r/w/x permissions.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/pgtable.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index 0b3e7c6..718991c 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -21,13 +21,6 @@
 struct mm_struct;
 struct vm_area_struct;
 
-#define PAGE_NONE	__pgprot(_PAGE_PRESENT | _CACHE_CACHABLE_NONCOHERENT)
-#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_WRITE | \
-				 _page_cachable_default)
-#define PAGE_COPY	__pgprot(_PAGE_PRESENT | _PAGE_NO_EXEC | \
-				 _page_cachable_default)
-#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | \
-				 _page_cachable_default)
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | __READABLE | __WRITEABLE | \
 				 _PAGE_GLOBAL | _page_cachable_default)
 #define PAGE_USERIO	__pgprot(_PAGE_PRESENT | _PAGE_WRITE | \
-- 
1.7.4.3

