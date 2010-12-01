Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0LARpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:45:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40857 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0LARpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=YSHmU67PU0wwbZp4QK3a9efi3up8EbsxpHNKPMFTpJJQB0HlY1yKVGbGXGYNI6w93N
         a335TEZ0NIw6SXDleKrhuxNwhMCckT9Pn7XoC7Bg7Jg85qN35swof4Z3KJXFT6oYFfKF
         sq2JIihV84l6eu0M7Ypw4Pyd1hFBwC7ziWCv4=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>
Subject: [PATCH 2/3] uwb: move whcrc_id_table under #ifdef MODULE
Date: Thu,  2 Dec 2010 02:45:28 +0900
Message-Id: <1291225529-1118-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
References: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since whcrc_id_table is used only for module auto-loading
move it under #ifdef MODULE to fix following warning:

  CC      drivers/uwb/whc-rc.o
drivers/uwb/whc-rc.c:452: warning: ‘whcrc_id_table’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
---
 drivers/uwb/whc-rc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/uwb/whc-rc.c b/drivers/uwb/whc-rc.c
index 7349558..e3bd62a 100644
--- a/drivers/uwb/whc-rc.c
+++ b/drivers/uwb/whc-rc.c
@@ -448,12 +448,14 @@ static int whcrc_post_reset(struct umc_dev *umc)
 	return uwb_rc_post_reset(uwb_rc);
 }
 
+#ifdef MODULE
 /* PCI device ID's that we handle [so it gets loaded] */
 static struct pci_device_id whcrc_id_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_WIRELESS_WHCI, ~0) },
 	{ /* empty last entry */ }
 };
 MODULE_DEVICE_TABLE(pci, whcrc_id_table);
+#endif
 
 static struct umc_driver whcrc_driver = {
 	.name       = "whc-rc",
-- 
1.7.0.4

