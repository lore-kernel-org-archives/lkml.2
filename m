Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1IFUpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:45:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51230 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1IFUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:45:28 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] Ensure we actually allow UDMA/100
Date: Tue,  6 Sep 2011 15:45:22 -0500
Message-Id: <1315341922-10286-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <4E6674CA.6020405@pobox.com>
References: <4E6674CA.6020405@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were limiting to UDMA/66 instead.
---
Jeff,

Can this get folded in? Just realized the bitmask I used from Alan's patch wasn't right as it didn't actually allow UDMA/100, it was setting the max at UDMA/66. This simple fixup has been boot tested.

-Dan

 drivers/ata/pata_sis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 54c41c7..810b7d6 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -526,7 +526,7 @@ static unsigned long sis_133_mode_filter(struct ata_device *adev, unsigned long
 	pci_read_config_dword(pdev, port, &t1);
 	/* if ATA133 is disabled, mask it out */
 	if (!(t1 & 0x08))
-		mask &= ~(0xE0 << ATA_SHIFT_UDMA);
+		mask &= ~(0xC0 << ATA_SHIFT_UDMA);
 	return mask;
 }
 
-- 
1.7.6.1

