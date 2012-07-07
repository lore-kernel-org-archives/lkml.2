Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2GGMGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2GGMFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:41 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 3/8] staging/ft1000: fix sparse warning
Date: Sat,  7 Jul 2012 17:35:14 +0530
Message-Id: <1341662719-25752-3-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse warns about having 0 assigned to a pointer,
fix it up by using NULL.

The following sparse warning is fixed

drivers/staging/ft1000/ft1000-usb/ft1000_debug.c:170:52: warning: Using plain integer as NULL pointer

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 19db23f..6d911fd 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -167,7 +167,7 @@ int ft1000_create_dev(struct ft1000_device *dev)
 		goto fail;
 	}
 
-	dir = debugfs_create_dir(info->DeviceName, 0);
+	dir = debugfs_create_dir(info->DeviceName, NULL);
 	if (IS_ERR(dir)) {
 		result = PTR_ERR(dir);
 		goto debug_dir_fail;
-- 
1.7.9.5

