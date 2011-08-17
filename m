Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1HQRHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:07:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62409 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab1HQRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:07:02 -0400
MIME-Version: 1.0
Date: Wed, 17 Aug 2011 19:07:01 +0200
Message-ID: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
Subject: [PATCH] Increase usbfs bulk buffer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd5692054930504aab68637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd5692054930504aab68637
Content-Type: text/plain; charset=ISO-8859-1

Hi,

this patch increases the maximum buffersize for bulk transfers, our
devices support at least up to 46k bytes for bulk transfers.
This patch allows us to lower the iterations between kernel and
userspace and lower the system pressure.

Signed-off-by: Markus Rechberger <mrechberger@gmail.com>

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..ad193d0 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -107,7 +107,7 @@ enum snoop_when {

 #define USB_DEVICE_DEV         MKDEV(USB_DEVICE_MAJOR, 0)

-#define        MAX_USBFS_BUFFER_SIZE   16384
+#define        MAX_USBFS_BUFFER_SIZE   46080


 static int connected(struct dev_state *ps)

--000e0cd5692054930504aab68637
Content-Type: text/x-patch; charset=US-ASCII; name="bulk_patch.diff"
Content-Disposition: attachment; filename="bulk_patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grgjsx000

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvZGV2aW8uYyBiL2RyaXZlcnMvdXNiL2NvcmUv
ZGV2aW8uYwppbmRleCAzNzUxOGRmLi5hZDE5M2QwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3VzYi9j
b3JlL2RldmlvLmMKKysrIGIvZHJpdmVycy91c2IvY29yZS9kZXZpby5jCkBAIC0xMDcsNyArMTA3
LDcgQEAgZW51bSBzbm9vcF93aGVuIHsKIAogI2RlZmluZSBVU0JfREVWSUNFX0RFVgkJTUtERVYo
VVNCX0RFVklDRV9NQUpPUiwgMCkKIAotI2RlZmluZQlNQVhfVVNCRlNfQlVGRkVSX1NJWkUJMTYz
ODQKKyNkZWZpbmUJTUFYX1VTQkZTX0JVRkZFUl9TSVpFCTQ2MDgwCiAKIAogc3RhdGljIGludCBj
b25uZWN0ZWQoc3RydWN0IGRldl9zdGF0ZSAqcHMpCg==
--000e0cd5692054930504aab68637--
