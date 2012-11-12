Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab2KLVbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:31:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2KLV2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:28:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.yuz extended stable] Patch "usb: gadget: at91_udc: fix dt support" has been added to staging queue
Date: Mon, 12 Nov 2012 19:28:35 -0200
Message-Id: <1352755716-15825-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    usb: gadget: at91_udc: fix dt support

to the linux-3.5.y-queue branch of the 3.5.yuz extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to the 3.5
Linux kernel, or for any feedback related to it, please reply to
this email. For more information on extended stable, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From b28eb5bd6675bbe7393b21e8611b9dc2411687ba Mon Sep 17 00:00:00 2001
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Fri, 7 Sep 2012 15:27:42 +0200
Subject: [PATCH] usb: gadget: at91_udc: fix dt support

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

