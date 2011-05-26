Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1EZHYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:24:53 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:34172 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1EZHYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:24:52 -0400
Message-ID: <4DDE003D.6040702@freemail.hu>
Date: Thu, 26 May 2011 09:24:45 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>, Arnd Bergmann <arnd@arndb.de>
CC: Julia Lawall <julia@diku.dk>, usbip-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbip: remove check for negative values for an unsigned value
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.49.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The parameter rhport is unsigned so there is no need checking for
negative values.

This will remove the following warning message when compiling with "make W=1 ...":
  drivers/staging/usbip/vhci_sysfs.c: In function ‘valid_args’:
  drivers/staging/usbip/vhci_sysfs.c:138: warning: comparison of unsigned expression < 0 is always false

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index d9736f9..7b6e4a9 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -135,7 +135,7 @@ static DEVICE_ATTR(detach, S_IWUSR, NULL, store_detach);
 static int valid_args(__u32 rhport, enum usb_device_speed speed)
 {
 	/* check rhport */
-	if ((rhport < 0) || (rhport >= VHCI_NPORTS)) {
+	if (rhport >= VHCI_NPORTS) {
 		pr_err("port %u\n", rhport);
 		return -EINVAL;
 	}
