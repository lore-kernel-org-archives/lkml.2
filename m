Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab0GAWXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:23:04 -0400
Received: from kroah.org ([198.145.64.141]:47119 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab0GAUt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:28 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:27 2010
Message-Id: <20100701173427.718097770@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Bombe <aeb@debian.org>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 010/164] ARCNET: Limit com20020 PCI ID matches for SOHARD cards
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Bombe <aeb@debian.org>

commit e7971c80a8e0299f91272ad8e8ac4167623e1862 upstream.

The SH SOHARD ARCNET cards are implemented using generic PLX Technology
PCI<->IOBus bridges. Subvendor and subdevice IDs were not specified,
causing the driver to attach to any such bridge and likely crash the
system by attempting to initialize an unrelated device.

Fix by specifying subvendor and subdevice according to the values found
in the PCI-ID Repository at http://pci-ids.ucw.cz/ .

Signed-off-by: Andreas Bombe <aeb@debian.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/arcnet/com20020-pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -165,8 +165,8 @@ static struct pci_device_id com20020pci_
 	{ 0x1571, 0xa204, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x1571, 0xa205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x1571, 0xa206, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
-	{ 0x10B5, 0x9030, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
-	{ 0x10B5, 0x9050, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
+	{ 0x10B5, 0x9030, 0x10B5,     0x2978,     0, 0, ARC_CAN_10MBIT },
+	{ 0x10B5, 0x9050, 0x10B5,     0x2273,     0, 0, ARC_CAN_10MBIT },
 	{ 0x14BA, 0x6000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x10B5, 0x2200, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{0,}


