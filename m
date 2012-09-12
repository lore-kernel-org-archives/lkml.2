Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IMAc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:32:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab2ILXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 064/108] rapidio/tsi721: fix unused variable compiler warning
Date: Wed, 12 Sep 2012 16:29:02 -0700
Message-Id: <20120912232457.246667866@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/tsi721.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2219,7 +2219,7 @@ static int __devinit tsi721_probe(struct
 				  const struct pci_device_id *id)
 {
 	struct tsi721_device *priv;
-	int i, cap;
+	int cap;
 	int err;
 	u32 regval;
 
@@ -2239,12 +2239,15 @@ static int __devinit tsi721_probe(struct
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


