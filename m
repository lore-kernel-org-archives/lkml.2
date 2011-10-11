Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1JKRGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:06:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:06:12 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:13 2011
Message-Id: <20111011165713.389661875@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:43 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Nelson <mdnelson8@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: [33/38] ahci: Enable SB600 64bit DMA on Asus M3A
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -812,6 +812,18 @@ static bool ahci_sb600_enable_64bit(stru
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


