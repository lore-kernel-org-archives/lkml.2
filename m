Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2E1DqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:46:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52066 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab2E1D33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:29 -0400
Message-Id: <20120528031212.812558190@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Johnson <johnso87@illinois.edu>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 072/117] ahci: Detect Marvell 88SE9172 SATA controller
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnson <johnso87@illinois.edu>

commit 642d89252201c4155fc3946bf9cdea409e5d263e upstream.

The Marvell 88SE9172 SATA controller (PCI ID 1b4b 917a) already worked
once it was detected, but was missing an ahci_pci_tbl entry.

Boot tested on a Gigabyte Z68X-UD3H-B3 motherboard.

Signed-off-by: Matt Johnson <johnso87@illinois.edu>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 79a1e9d..ebaf67e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -394,6 +394,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(0x1b4b, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE(0x1b4b, 0x917a),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 


