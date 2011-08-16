Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1HPSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:25:07 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:10887 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1HPSZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:25:06 -0400
From: David Daney <david.daney@cavium.com>
To: linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] pci/of: Don't crash when bridge parent is NULL.
Date: Tue, 16 Aug 2011 11:24:37 -0700
Message-Id: <1313519077-18457-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 16 Aug 2011 18:24:57.0577 (UTC) FILETIME=[CD696D90:01CC5C41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pcibios_get_phb_of_node(), we will crash while booting if
bus->bridge->parent is NULL.

Check for this case and avoid dereferencing the NULL pointer.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/pci/of.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index c94d37e..f092993 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -55,7 +55,7 @@ struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
 	 */
 	if (bus->bridge->of_node)
 		return of_node_get(bus->bridge->of_node);
-	if (bus->bridge->parent->of_node)
+	if (bus->bridge->parent && bus->bridge->parent->of_node)
 		return of_node_get(bus->bridge->parent->of_node);
 	return NULL;
 }
-- 
1.7.2.3

