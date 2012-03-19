Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162041Ab2CSFt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25512 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161952Ab2CSFtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 15/26] PCI: Use for_each_res pci bases pci_dev_driver()
Date: Sun, 18 Mar 2012 22:48:38 -0700
Message-Id: <1332136129-14010-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F66C8FD.0088,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-driver.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 5d19695..a82c66f 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1201,9 +1201,11 @@ pci_dev_driver(const struct pci_dev *dev)
 	if (dev->driver)
 		return dev->driver;
 	else {
+		struct resource *res;
 		int i;
-		for(i=0; i<=PCI_ROM_RESOURCE; i++)
-			if (dev->resource[i].flags & IORESOURCE_BUSY)
+
+		for_each_pci_dev_base_resource((struct pci_dev *)dev, res, i)
+			if (res->flags & IORESOURCE_BUSY)
 				return &pci_compat_driver;
 	}
 	return NULL;
-- 
1.7.7

