Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395Ab2B2XJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:22 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25840 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2B2XIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/39] PCI: release busn when removing bus
Date: Wed, 29 Feb 2012 15:07:21 -0800
Message-Id: <1330556858-11768-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090202.4F4EAFE7.00AC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index fd77e2b..04a4861 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -68,6 +68,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 
 	down_write(&pci_bus_sem);
 	list_del(&pci_bus->node);
+	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
 	if (!pci_bus->is_added)
 		return;
-- 
1.7.7

