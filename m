Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2KWFqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:46:11 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56738 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2KWFqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:46:10 -0500
X-Greylist: delayed 24480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2012 00:46:10 EST
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX PATCH] USB: chipidea: fix use after free bug
Date: Thu, 22 Nov 2012 10:11:25 +0100
Message-Id: <1353575485-23941-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer to a platform_device struct must not be dereferenced after
the device has been unregistered.

This bug produces a crash when unloading the ci13xxx kernel module
compiled with CONFIG_PAGE_POISONING enabled.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/chipidea/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index f69d029..b726c49 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -385,8 +385,9 @@ EXPORT_SYMBOL_GPL(ci13xxx_add_device);
 
 void ci13xxx_remove_device(struct platform_device *pdev)
 {
+	int id = pdev->id;
 	platform_device_unregister(pdev);
-	ida_simple_remove(&ci_ida, pdev->id);
+	ida_simple_remove(&ci_ida, id);
 }
 EXPORT_SYMBOL_GPL(ci13xxx_remove_device);
 
-- 
1.7.2.5

