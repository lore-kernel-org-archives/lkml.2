Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2FZSzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:55:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36849 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744Ab2FZSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:55:14 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v12 06/15] PCI: Add pci_bus_replace_busn_res()
Date: Tue, 26 Jun 2012 11:54:00 -0700
Message-Id: <1340736849-14875-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will use replace_resource to put bus's busn_res in the resource tree.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 75bca6f..7498502 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -660,6 +660,21 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
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
+	replace_resource(busn_res, res);
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

