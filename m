Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2DCMsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:48:38 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50848 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2DCMsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:48:37 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] devicetree: pull evaluation of of_address_to_resource() out of loop in of_dev_lookup()
Date: Tue,  3 Apr 2012 14:48:28 +0200
Message-Id: <1333457308-6005-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of_address_to_resource(np, 0, &res) is independent from the
for (; lookup->compatible != NULL; lookup++) {
}
loop evaluation. Evaluate it once before entering the loop.

Also add a space between 'for' keyword and parens.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/of/platform.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 343ad29..528405f 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -314,11 +314,12 @@ static const struct of_dev_auxdata *of_dev_lookup(const struct of_dev_auxdata *l
 	if (!lookup)
 		return NULL;
 
-	for(; lookup->compatible != NULL; lookup++) {
+	if (of_address_to_resource(np, 0, &res))
+		return NULL;
+
+	for (; lookup->compatible != NULL; lookup++) {
 		if (!of_device_is_compatible(np, lookup->compatible))
 			continue;
-		if (of_address_to_resource(np, 0, &res))
-			continue;
 		if (res.start != lookup->phys_addr)
 			continue;
 		pr_debug("%s: devname=%s\n", np->full_name, lookup->name);
-- 
1.7.2.5

