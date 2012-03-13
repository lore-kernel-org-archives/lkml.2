Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2CMLiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:38:00 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:11366
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700Ab2CMLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:37:59 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>
Subject: [PATCH 1/1] of: add NULL parameter check for of_device_is_available
Date: Tue, 13 Mar 2012 19:40:05 +0800
Message-ID: <1331638805-17136-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

This function will return 1 even the device node passed in
is NULL which is a little error-prone.
Change to return 0 if the device node passed in is NULL.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/of/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 133908a..b9347d8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -280,6 +280,9 @@ int of_device_is_available(const struct device_node *device)
 	const char *status;
 	int statlen;
 
+	if (device == NULL)
+		return 0;
+
 	status = of_get_property(device, "status", &statlen);
 	if (status == NULL)
 		return 1;
-- 
1.7.0.4


