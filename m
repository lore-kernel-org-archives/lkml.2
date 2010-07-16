Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab0GPQOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:14:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47870 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966030Ab0GPQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eVxXz2vSlqoJxOT0tpAr+YyLmj7SuYuL3OKZkXo2gdpPA9FsJGeHAg59ort64yW7dh
         PW7zCBbOdzeFzjuGL0G0cltsPtGUralDeIK/FqY1jrBVyjwVeCFNn3dgDCKFOrTyCSvs
         gY2m41B3XDkpIuGeS6NrQgf2PVhBecOoKaGP0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>,
        Michel Ludwig <michel.ludwig@gmail.com>,
        "Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] staging: tm6000: check kzalloc() result
Date: Fri, 16 Jul 2010 20:14:33 +0400
Message-Id: <1279296873-25023-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/tm6000/tm6000-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 2c38199..9c2829e 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -40,8 +40,11 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	static int   ini = 0, last = 0, n = 0;
 	u8	     *data = NULL;
 
-	if (len)
+	if (len) {
 		data = kzalloc(len, GFP_KERNEL);
+		if (data == NULL)
+			return -ENOMEM;
+	}
 
 
 	if (req_type & USB_DIR_IN)
-- 
1.7.0.4

