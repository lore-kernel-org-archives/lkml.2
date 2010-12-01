Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0LARpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:45:45 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52387 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab0LARpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=c4UtfLhL66RveieAM75a09zRycaszQBk9fclyjnQ1EXsCPL8nSoyQHfNZMmiaPvsyk
         KUiysXBZkV5DE3IENvEz8wlHNRkEduPUpfGxjnaKYHdmxvE+7QPHXgmlD8kgpT1vsvSe
         mtVfeZlssXoabBF77zvhzDHoR0z5ncnVMsGUU=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>
Subject: [PATCH 3/3] uwb: move i1480_est_id_table under #ifdef MODULE
Date: Thu,  2 Dec 2010 02:45:29 +0900
Message-Id: <1291225529-1118-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
References: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since i1480_est_id_table is used only for module auto-loading
move it under #ifdef MODULE to fix following warning:

  CC      drivers/uwb/i1480/i1480-est.o
drivers/uwb/i1480/i1480-est.c:94: warning: ‘i1480_est_id_table’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
---
 drivers/uwb/i1480/i1480-est.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/uwb/i1480/i1480-est.c b/drivers/uwb/i1480/i1480-est.c
index f2eb4d8..bcbaea2 100644
--- a/drivers/uwb/i1480/i1480-est.c
+++ b/drivers/uwb/i1480/i1480-est.c
@@ -86,6 +86,7 @@ MODULE_AUTHOR("Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>");
 MODULE_DESCRIPTION("i1480's Vendor Specific Event Size Tables");
 MODULE_LICENSE("GPL");
 
+#ifdef MODULE
 /**
  * USB device ID's that we handle
  *
@@ -97,3 +98,4 @@ static struct usb_device_id i1480_est_id_table[] = {
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, i1480_est_id_table);
+#endif
-- 
1.7.0.4

