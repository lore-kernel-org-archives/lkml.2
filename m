Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab2JZOcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:32:17 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:34629 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab2JZOcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:12 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] h8300: Remove unnecessary prototypes for kobjsize() and is_in_rom()
Date: Fri, 26 Oct 2012 16:32:08 +0200
Message-Id: <1351261928-23443-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.10.26.142120
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_900_999 0, RDNS_NXDOMAIN 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype for kobjsize() is already defined in linux/mm.h
which is included where kobjsize() is used.

is_in_rom() is neither defined nor used across the whole tree, so delete
the prototype.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/h8300/include/asm/pgtable.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/h8300/include/asm/pgtable.h b/arch/h8300/include/asm/pgtable.h
index 62ef176..cc51c6c 100644
--- a/arch/h8300/include/asm/pgtable.h
+++ b/arch/h8300/include/asm/pgtable.h
@@ -42,12 +42,6 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define ZERO_PAGE(vaddr)	(virt_to_page(0))
 
 /*
- * These would be in other places but having them here reduces the diffs.
- */
-extern unsigned int kobjsize(const void *objp);
-extern int is_in_rom(unsigned long);
-
-/*
  * No page table caches to initialise
  */
 #define pgtable_cache_init()   do { } while (0)
-- 
1.7.5.4

