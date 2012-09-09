Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2IIXQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062Ab2IIXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:33 -0400
Message-Id: <20120909224201.057584373@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: [ 76/95] rapidio/tsi721: fix unused variable compiler warning
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 9a9a9a7adafe62a34de8b4fb48936c1c5f9bafa5 upstream.

Fix unused variable compiler warning when built with CONFIG_RAPIDIO_DEBUG
option off.

This patch is applicable to kernel versions starting from v3.2

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rapidio/devices/tsi721.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index c0d6a04..5d44252 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2219,7 +2219,7 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *id)
 {
 	struct tsi721_device *priv;
-	int i, cap;
+	int cap;
 	int err;
 	u32 regval;
 
@@ -2239,12 +2239,15 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
 	priv->pdev = pdev;
 
 #ifdef DEBUG
+	{
+	int i;
 	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
 		dev_dbg(&pdev->dev, "res[%d] @ 0x%llx (0x%lx, 0x%lx)\n",
 			i, (unsigned long long)pci_resource_start(pdev, i),
 			(unsigned long)pci_resource_len(pdev, i),
 			pci_resource_flags(pdev, i));
 	}
+	}
 #endif
 	/*
 	 * Verify BAR configuration


