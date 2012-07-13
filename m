Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2GMVUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:20:47 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40954 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2GMVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:20:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6/6] m32r: Make memset() global for CONFIG_KERNEL_BZIP2=y
Date: Fri, 13 Jul 2012 23:20:27 +0200
Message-Id: <1342214427-17607-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
References: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/m32r/boot/compressed/misc.c:31:14: error: static declaration of 'memset' follows non-static declaration
make[5]: *** [arch/m32r/boot/compressed/misc.o] Error 1
make[4]: *** [arch/m32r/boot/compressed/vmlinux] Error 2

Remove the static keyword to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m32r/boot/compressed/misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/boot/compressed/misc.c b/arch/m32r/boot/compressed/misc.c
index 3147aa2..28a0952 100644
--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -28,7 +28,7 @@ static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
 #ifdef CONFIG_KERNEL_BZIP2
-static void *memset(void *s, int c, size_t n)
+void *memset(void *s, int c, size_t n)
 {
 	char *ss = s;
 
-- 
1.7.0.4

