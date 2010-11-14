Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0KNMc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 07:32:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:33228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0KNMc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 07:32:27 -0500
Subject: [PATCH] sata-via: enable magic transmission fix for vt6420
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Joseph Chan <JosephChan@via.com.tw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Nov 2010 13:31:51 +0100
Message-ID: <1289737911.24491.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was able to reproduce and test the transmission error on vt6420
hardware with the 2G WD drives. Adding the controller ID to this fix
seems to result in a properly working system.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/ata/sata_via.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 4730c42..2822492 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -577,7 +577,7 @@ static void svia_configure(struct pci_dev *pdev)
 	}
 
 	/*
-	 * vt6421 has problems talking to some drives.  The following
+	 * vt642[01] has problems talking to some drives.  The following
 	 * is the fix from Joseph Chan <JosephChan@via.com.tw>.
 	 *
 	 * When host issues HOLD, device may send up to 20DW of data
@@ -597,7 +597,7 @@ static void svia_configure(struct pci_dev *pdev)
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=15173
 	 * http://article.gmane.org/gmane.linux.ide/46352
 	 */
-	if (pdev->device == 0x3249) {
+	if (pdev->device == 0x3249 || pdev->device == 0x3149) {
 		pci_read_config_byte(pdev, 0x52, &tmp8);
 		tmp8 |= 1 << 2;
 		pci_write_config_byte(pdev, 0x52, tmp8);

