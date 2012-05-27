Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab2E0Bq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:46:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab2E0BIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:08:37 -0400
Message-Id: <20120527010427.995132979@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:53 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Johnson <johnso87@illinois.edu>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 30/94] ahci: Detect Marvell 88SE9172 SATA controller
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnson <johnso87@illinois.edu>

commit 642d89252201c4155fc3946bf9cdea409e5d263e upstream.

The Marvell 88SE9172 SATA controller (PCI ID 1b4b 917a) already worked
once it was detected, but was missing an ahci_pci_tbl entry.

Boot tested on a Gigabyte Z68X-UD3H-B3 motherboard.

Signed-off-by: Matt Johnson <johnso87@illinois.edu>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -386,6 +386,8 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(0x1b4b, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE(0x1b4b, 0x917a),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 


