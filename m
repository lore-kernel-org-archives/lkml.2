Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030829Ab2CSFpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:45:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29931 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030796Ab2CSFpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:45:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v11 21/30] PCI: Add pci_bus_replace_busn_res()
Date: Sun, 18 Mar 2012 22:42:52 -0700
Message-Id: <1332135781-13695-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F66C7FC.008F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will use resource_replace to put bus's busn_res in the resource tree.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 67cd0a7..c5fe935 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -626,6 +626,21 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	return child;
 }
 
+static void pci_bus_replace_busn_res(struct pci_bus *b,
+					 struct resource *busn_res)
+{
+	struct resource *res = &b->busn_res;
+
+	/* busn_res must be registered already*/
+	if (!busn_res->parent)
+		return;
+
+	resource_replace(busn_res, res);
+
+	dev_printk(KERN_DEBUG, &b->dev, "busn_res: %pR is updated under %pR\n",
+			res, res->parent);
+}
+
 struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
 {
 	struct pci_bus *child;
-- 
1.7.7

