Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1EYJLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:11:10 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:42744 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1EYJLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:11:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] m68knommu: Fix printk() format in free_initrd_mem()
Date: Wed, 25 May 2011 11:11:00 +0200
Message-Id: <1306314660-19288-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>
References: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/m68k/mm/init_no.c:123: warning: format ‘%d’ expects type ‘int’, but argument 2 has type ‘long unsigned int’

And use pr_notice() while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/init_no.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
index fdbe679..50cd12c 100644
--- a/arch/m68k/mm/init_no.c
+++ b/arch/m68k/mm/init_no.c
@@ -120,7 +120,8 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 		totalram_pages++;
 		pages++;
 	}
-	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
+	pr_notice("Freeing initrd memory: %luk freed\n",
+		  pages * (PAGE_SIZE / 1024));
 }
 #endif
 
@@ -141,7 +142,7 @@ void free_initmem(void)
 		free_page(addr);
 		totalram_pages++;
 	}
-	printk(KERN_NOTICE "Freeing unused kernel memory: %ldk freed (0x%x - 0x%x)\n",
+	pr_notice("Freeing unused kernel memory: %luk freed (0x%x - 0x%x)\n",
 			(addr - PAGE_ALIGN((long) &__init_begin)) >> 10,
 			(int)(PAGE_ALIGN((unsigned long)(&__init_begin))),
 			(int)(addr - PAGE_SIZE));
-- 
1.7.0.4

