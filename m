Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161872Ab2CSFtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31197 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161768Ab2CSFta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 01/26] PCI: Add pci_dev_resource_n()
Date: Sun, 18 Mar 2012 22:48:24 -0700
Message-Id: <1332136129-14010-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F66C8E8.0003,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare to use it with addon_resource and for_each_resource macro.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   10 ++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d626c4e..87e87b5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -75,6 +75,16 @@ static int __init pcibus_class_init(void)
 }
 postcore_initcall(pcibus_class_init);
 
+struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
+{
+	struct pci_dev_addon_resource *addon_res;
+
+	if (n < PCI_NUM_RESOURCES)
+		return &dev->resource[n];
+
+	return NULL;
+}
+
 static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
 	u64 size = mask & maxbase;	/* Find the significant bits */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 161f6c0..bb81080 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -347,6 +347,8 @@ struct pci_dev {
 #endif
 };
 
+struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
+
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_IOV
-- 
1.7.7

