Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1KTTKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 14:10:16 -0500
Received: from www17.your-server.de ([213.133.104.17]:33243 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1KTTJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 14:09:55 -0500
Message-ID: <1321702059.1624.324.camel@localhost.localdomain>
Subject: [PATCH] ia64: tioca: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: jes@sgi.com, tony.luck@intel.com, fenghua.yu@intel.com,
        linux-altix@sgi.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 12:27:39 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
--- a/arch/ia64/sn/pci/tioca_provider.c 2011-11-07 19:39:05.034456070 +0100
+++ b/arch/ia64/sn/pci/tioca_provider.c 2011-11-08 11:01:35.744740824 +0100
@@ -600,11 +600,11 @@ tioca_bus_fixup(struct pcibus_bussoft *p
 	 * Allocate kernel bus soft and copy from prom.
 	 */
 
-	tioca_common = kzalloc(sizeof(struct tioca_common), GFP_KERNEL);
+	tioca_common = kmemdup(prom_bussoft, sizeof(struct tioca_common),
+			       GFP_KERNEL);
 	if (!tioca_common)
 		return NULL;
 
-	memcpy(tioca_common, prom_bussoft, sizeof(struct tioca_common));
 	tioca_common->ca_common.bs_base = (unsigned long)
 		ioremap(REGION_OFFSET(tioca_common->ca_common.bs_base),
 			sizeof(struct tioca_common));


