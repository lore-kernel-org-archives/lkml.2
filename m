Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2GUHWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:22:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47858 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GUHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:22:24 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 3/3] staging/csr: remove firmware pointer check before giving to release_firmware
Date: Sat, 21 Jul 2012 13:07:17 +0545
Message-Id: <1342855337-2872-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we do a check of firmware pointer against the NULL value before we give
it to the release_firmware.

as release_firmware is actually having a check against NULL, its not needed
here.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/firmware.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/csr/firmware.c b/drivers/staging/csr/firmware.c
index d14e118..dc6a04d 100644
--- a/drivers/staging/csr/firmware.c
+++ b/drivers/staging/csr/firmware.c
@@ -402,9 +402,7 @@ int uf_release_firmware_files(unifi_priv_t *priv)
 int uf_release_firmware(unifi_priv_t *priv, struct dlpriv *to_free)
 {
     if (to_free != NULL) {
-        if (to_free->fw_desc != NULL) {
-            release_firmware((const struct firmware *)to_free->fw_desc);
-        }
+        release_firmware((const struct firmware *)to_free->fw_desc);
         to_free->fw_desc = NULL;
         to_free->dl_data = NULL;
         to_free->dl_len = 0;
-- 
1.7.9.5

