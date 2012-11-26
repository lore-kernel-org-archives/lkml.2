Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2KZQ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:59:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46992 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2KZQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:59:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 002/270] usb: gadget: at91_udc: fix dt support
Date: Mon, 26 Nov 2012 14:54:52 -0200
Message-Id: <1353949160-26803-3-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 9c6d196d5aa35e07482f23c3e37755e7a82140e0 upstream.

Don't fail the initialization check for the platform_data
if there is avaiable an associated device tree node.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/at91_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 22865dd..aad16ac 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1698,7 +1698,7 @@ static int __devinit at91udc_probe(struct platform_device *pdev)
 	int		retval;
 	struct resource	*res;
 
-	if (!dev->platform_data) {
+	if (!dev->platform_data && !pdev->dev.of_node) {
 		/* small (so we copy it) but critical! */
 		DBG("missing platform_data\n");
 		return -ENODEV;
-- 
1.7.9.5

