Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1KSL3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:29:47 -0500
Received: from www17.your-server.de ([213.133.104.17]:41073 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1KSL3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:29:39 -0500
Message-ID: <1321701965.1624.323.camel@localhost.localdomain>
Subject: [PATCH] ia64: pcibr: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: jes@sgi.com, tony.luck@intel.com, fenghua.yu@intel.com,
        linux-altix@sgi.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 12:26:05 +0100
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

diff -u -p a/arch/ia64/sn/pci/pcibr/pcibr_provider.c b/arch/ia64/sn/pci/pcibr/pcibr_provider.c
--- a/arch/ia64/sn/pci/pcibr/pcibr_provider.c 2011-11-07 19:39:05.034456070 +0100
+++ b/arch/ia64/sn/pci/pcibr/pcibr_provider.c 2011-11-08 11:01:35.484737338 +0100
@@ -127,12 +127,11 @@ pcibr_bus_fixup(struct pcibus_bussoft *p
 	 * Allocate kernel bus soft and copy from prom.
 	 */
 
-	soft = kmalloc(sizeof(struct pcibus_info), GFP_KERNEL);
+	soft = kmemdup(prom_bussoft, sizeof(struct pcibus_info), GFP_KERNEL);
 	if (!soft) {
 		return NULL;
 	}
 
-	memcpy(soft, prom_bussoft, sizeof(struct pcibus_info));
 	soft->pbi_buscommon.bs_base = (unsigned long)
 		ioremap(REGION_OFFSET(soft->pbi_buscommon.bs_base),
 			sizeof(struct pic));


