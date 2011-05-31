Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1EaHaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:30:15 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:35694 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1EaHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:30:14 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/amiga: Chip RAM - Offset resource end by CHIP_PHYSADDR
Date: Tue, 31 May 2011 09:30:08 +0200
Message-Id: <1306827008-15329-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technically, the end of Chip RAM should be offset by CHIP_PHYSADDR (which is
zero).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index 9d53417..99449fb 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -34,7 +34,7 @@ void __init amiga_chip_init(void)
 	if (!AMIGAHW_PRESENT(CHIP_RAM))
 		return;
 
-	chipram_res.end = amiga_chip_size-1;
+	chipram_res.end = CHIP_PHYSADDR + amiga_chip_size - 1;
 	request_resource(&iomem_resource, &chipram_res);
 
 	atomic_set(&chipavail, amiga_chip_size);
-- 
1.7.0.4

