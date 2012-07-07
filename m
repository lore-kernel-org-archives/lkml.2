Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2GGMG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2GGMFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:47 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 4/8] staging/ft1000: fix sparse warning about the kernel thread handler function
Date: Sat,  7 Jul 2012 17:35:15 +0530
Message-Id: <1341662719-25752-4-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse throws warning about the ft1000_poll_thread as

drivers/staging/ft1000/ft1000-usb/ft1000_usb.c:40:5: warning: symbol 'ft1000_poll_thread' was not declared. Should it be static?

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index bfead67..e434d33 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -37,7 +37,7 @@ static struct usb_device_id id_table[] = {
 MODULE_DEVICE_TABLE(usb, id_table);
 
 static bool gPollingfailed = FALSE;
-int ft1000_poll_thread(void *arg)
+static int ft1000_poll_thread(void *arg)
 {
 	int ret = STATUS_SUCCESS;
 
-- 
1.7.9.5

