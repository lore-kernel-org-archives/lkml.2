Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2FSMpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:45:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53877 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2FSMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:45:34 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/3] staging/ft1000: Return -ENOMEM if kmalloc fails at ft1000_probe
Date: Tue, 19 Jun 2012 18:15:25 +0530
Message-Id: <1340109925-30472-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kmalloc fails return -ENOMEM , returning 0 is not the proper
way if any function fails

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 84c38d5..a07c504 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -71,7 +71,7 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	if (!ft1000dev) {
 		printk(KERN_ERR "out of memory allocating device structure\n");
-		return 0;
+		return -ENOMEM;
 	}
 
 	memset(ft1000dev, 0, sizeof(*ft1000dev));
-- 
1.7.9.5

