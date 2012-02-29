Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531Ab2B2XJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:29 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25914 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab2B2XIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/39] PCI: skip busn resource at first.
Date: Wed, 29 Feb 2012 15:07:15 -0800
Message-Id: <1330556858-11768-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F4EAFEB.00AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busn_alloc code is not there yet. so need to skip it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 675d7ed..3bdc421 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1648,6 +1648,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	list_for_each_entry_safe(window, n, resources, list) {
 		list_move_tail(&window->list, &bridge->windows);
 		res = window->res;
+		if (res->flags & IORESOURCE_BUS)
+			continue;
 		offset = window->offset;
 		pci_bus_add_resource(b, res, 0);
 		if (offset) {
-- 
1.7.7

