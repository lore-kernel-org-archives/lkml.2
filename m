Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2D0Gro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:47:44 -0400
Received: from citesht4.cites.illinois.edu ([192.17.212.154]:20156 "EHLO
	citesht4.cites.illinois.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632Ab2D0Grk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:47:40 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 02:47:40 EDT
Message-ID: <4F9A3FD6.7060206@illinois.edu>
Date: Fri, 27 Apr 2012 01:42:30 -0500
From: Matt Johnson <johnso87@illinois.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: <jgarzik@pobox.com>
CC: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: [PATCH 1/1] ahci: Detect Marvell 88SE9172 SATA controller
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.17.212.130]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell 88SE9172 SATA controller (PCI ID 1b4b 917a) already worked
once it was detected, but was missing an ahci_pci_tbl entry.

Boot tested on a Gigabyte Z68X-UD3H-B3 motherboard.

Signed-off-by: Matt Johnson <johnso87@illinois.edu>
---
  drivers/ata/ahci.c |    2 ++
  1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 79a1e9d..ebaf67e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -394,6 +394,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
           .driver_data = board_ahci_yes_fbs },                  /* 
88se9128 */
         { PCI_DEVICE(0x1b4b, 0x9125),
           .driver_data = board_ahci_yes_fbs },                  /* 
88se9125 */
+       { PCI_DEVICE(0x1b4b, 0x917a),
+         .driver_data = board_ahci_yes_fbs },                  /* 
88se9172 */
         { PCI_DEVICE(0x1b4b, 0x91a3),
           .driver_data = board_ahci_yes_fbs },

-- 
1.7.9.5
