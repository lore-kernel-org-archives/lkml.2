Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161928Ab2CSFzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:55:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25406 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161768Ab2CSFte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:34 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 03/26] PCI: Add pci_dev_resource_idx()
Date: Sun, 18 Mar 2012 22:48:26 -0700
Message-Id: <1332136129-14010-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F66C8EB.00BB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   12 ++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 87e87b5..7d5550a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -85,6 +85,18 @@ struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
 	return NULL;
 }
 
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
+{
+	int i;
+	struct resource *r;
+
+	for_each_pci_dev_all_resource(dev, r, i)
+		if (r == res)
+			return i;
+
+	return -1;
+}
+
 static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
 	u64 size = mask & maxbase;	/* Find the significant bits */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2b1fff8..e3f9ae1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -348,6 +348,7 @@ struct pci_dev {
 };
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
 
 #define resno_is_for_bridge(n)						\
 	((n) >= PCI_BRIDGE_RESOURCES && (n) <= PCI_BRIDGE_RESOURCE_END)
-- 
1.7.7

