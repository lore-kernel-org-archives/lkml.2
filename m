Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab1KCBed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:34:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab1KCBeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.325861186@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Nelson <mdnelson8@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [046/107] ahci: Enable SB600 64bit DMA on Asus M3A
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Nelson <mdnelson8@gmail.com>

commit 3c4aa91f21f65b7b40bdfb015eacbcb8453ccae2 upstream.

Like e65cc194f7628ecaa02462f22f42fb09b50dcd49 this patch enables 64bit DMA
for the AHCI SATA controller of a board that has the SB600 southbridge. In
this case though we're enabling 64bit DMA for the Asus M3A motherboard. It
is a new enough board that all of the BIOS releases since the initial
release (0301 from 2007-10-22) work correctly with 64bit DMA enabled.

Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2769,6 +2769,18 @@ static bool ahci_sb600_enable_64bit(stru
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


