Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab1EFAji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:39:38 -0400
Received: from kroah.org ([198.145.64.141]:37321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab1EFAZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002217.682955874@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>, "David S. Miller" <davem@davemloft.net>
Subject: [126/143] ipg: Remove device claimed by dl2k from pci id table
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 25cca5352712561fba97bd37c495593d641c1d39 upstream.

This patch removes D-Link DGE-550T PCI ID (1186:4000) from the ipg
driver. The ipg driver is for IP2000-based cards and the DGE-550T is
a DL2000-based card. The driver loads and works for a few moments, but
once a real workload is applied it stops operating. The ipg driver
claimed this ID since it was introduced in 2.6.24 and it's forced many
users to blacklist it.

The correct driver for this hardware is the dl2k driver, which has been
claiming this PCI ID since the 2.4 days.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/ipg.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -88,7 +88,6 @@ static const char *ipg_brand_name[] = {
 	"Sundance Technology ST2021 based NIC",
 	"Tamarack Microelectronics TC9020/9021 based NIC",
 	"Tamarack Microelectronics TC9020/9021 based NIC",
-	"D-Link NIC",
 	"D-Link NIC IP1000A"
 };
 
@@ -97,8 +96,7 @@ static struct pci_device_id ipg_pci_tbl[
 	{ PCI_VDEVICE(SUNDANCE,	0x2021), 1 },
 	{ PCI_VDEVICE(SUNDANCE,	0x1021), 2 },
 	{ PCI_VDEVICE(DLINK,	0x9021), 3 },
-	{ PCI_VDEVICE(DLINK,	0x4000), 4 },
-	{ PCI_VDEVICE(DLINK,	0x4020), 5 },
+	{ PCI_VDEVICE(DLINK,	0x4020), 4 },
 	{ 0, }
 };
 


