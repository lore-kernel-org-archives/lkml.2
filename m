Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab2B2XJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:31 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25963 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2B2XIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:43 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 23/39] PCI: insert busn_res in pci_create_root_bus
Date: Wed, 29 Feb 2012 15:07:22 -0800
Message-Id: <1330556858-11768-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090208.4F4EAFF1.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that busn_res is from resources list

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5efcf1a..e32f1b7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1655,10 +1655,11 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	list_for_each_entry_safe(window, n, resources, list) {
 		list_move_tail(&window->list, &bridge->windows);
 		res = window->res;
-		if (res->flags & IORESOURCE_BUS)
-			continue;
 		offset = window->offset;
-		pci_bus_add_resource(b, res, 0);
+		if (res->flags & IORESOURCE_BUS)
+			pci_bus_insert_busn_res(b, res->start, res->end);
+		else
+			pci_bus_add_resource(b, res, 0);
 		if (offset) {
 			if (resource_type(res) == IORESOURCE_IO)
 				fmt = " (bus address [%#06llx-%#06llx])";
-- 
1.7.7

