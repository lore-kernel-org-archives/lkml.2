Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871Ab2KUVCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 16:02:44 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:38886 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825Ab2KUVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 16:02:43 -0500
Date: Wed, 21 Nov 2012 14:02:40 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of: When constructing the bus id consider assigned-addresses
 as well
Message-ID: <20121121210240.GC15285@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'assigned-addresses' is used for certain PCI device type nodes in
lieu of 'reg',  since this is enforced by of/address.c, have
of_device_make_bus_id look there as well.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/of/platform.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

of_can_translate_address and of_translate_address already support
using assigned-addresses.

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b80891b..4f0f701 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -105,6 +105,8 @@ void of_device_make_bus_id(struct device *dev)
 	 * For MMIO, get the physical address
 	 */
 	reg = of_get_property(node, "reg", NULL);
+	if (!reg)
+		reg = of_get_property(node, "assigned-addresses", NULL);
 	if (reg) {
 		if (of_can_translate_address(node)) {
 			addr = of_translate_address(node, reg);
-- 
1.7.5.4

