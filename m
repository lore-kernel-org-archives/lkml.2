Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1EUTSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:18:36 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40121 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1EUTS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:18:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] m68k/amiga: Chip RAM - Use resource_size() to fix off-by-one error
Date: Sat, 21 May 2011 21:18:20 +0200
Message-Id: <1306005500-29259-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
References: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index c3fe451..cfd3b7a 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -100,7 +100,7 @@ void amiga_chip_free(void *ptr)
 		if (res->start != start)
 			continue;
 		*p = res->sibling;
-		size = res->end-start;
+		size = resource_size(res);
 		pr_debug("amiga_chip_free: free %lu bytes at %p\n", size, ptr);
 		atomic_add(size, &chipavail);
 		kfree(res);
-- 
1.7.0.4

