Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab2HOU0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:26:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:36769 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2HOTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Nelson <mdnelson8@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 059/165] ahci: Enable SB600 64bit DMA on Asus M3A
Date: Wed, 15 Aug 2012 15:46:43 -0400
Message-ID: <1345060109-9187-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Nelson <mdnelson8@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3c4aa91f21f65b7b40bdfb015eacbcb8453ccae2 upstream.

Like e65cc194f7628ecaa02462f22f42fb09b50dcd49 this patch enables 64bit DMA
for the AHCI SATA controller of a board that has the SB600 southbridge. In
this case though we're enabling 64bit DMA for the Asus M3A motherboard. It
is a new enough board that all of the BIOS releases since the initial
release (0301 from 2007-10-22) work correctly with 64bit DMA enabled.

Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/ahci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9215998..a5b1fd9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2981,6 +2981,18 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
 			},
 		},
+		/*
+		 * All BIOS versions for the Asus M3A support 64bit DMA.
+		 * (all release versions from 0301 to 1206 were tested)
+		 */
+		{
+			.ident = "ASUS M3A",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK Computer INC."),
+				DMI_MATCH(DMI_BOARD_NAME, "M3A"),
+			},
+		},
 		{ }
 	};
 	const struct dmi_system_id *match;
-- 
1.7.12.rc2

