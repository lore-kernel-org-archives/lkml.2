Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab0LAUwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:52:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38815 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab0LAUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:52:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=lDppiyDrgvmTSf2ysfVMs6GLsC3jLE4tRsbKhMgxohEZtJl4nQLytFboXiMzX44hBW
         cIP738R3g0tUzjls8wJRel62Ta2zwF2OBHaT8vxtax/av6bNJ+AykdUEnJhE1kGsEl0s
         nkGztVGqEGCvrhRGHOq9XYJxd7f05Ekuz78Oo=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>
Subject: [PATCH v2 2/2] uwb: fix compiler warning on i1480_est_id_table
Date: Thu,  2 Dec 2010 05:52:22 +0900
Message-Id: <1291236742-2080-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291236742-2080-1-git-send-email-namhyung@gmail.com>
References: <1291236742-2080-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate i1480_est_id_table as '__used' to fix following warning:

  CC      drivers/uwb/i1480/i1480-est.o
drivers/uwb/i1480/i1480-est.c:94: warning: ‘i1480_est_id_table’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
---
 drivers/uwb/i1480/i1480-est.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/i1480/i1480-est.c b/drivers/uwb/i1480/i1480-est.c
index f2eb4d8..d5de5e1 100644
--- a/drivers/uwb/i1480/i1480-est.c
+++ b/drivers/uwb/i1480/i1480-est.c
@@ -91,7 +91,7 @@ MODULE_LICENSE("GPL");
  *
  * [so we are loaded when this kind device is connected]
  */
-static struct usb_device_id i1480_est_id_table[] = {
+static struct usb_device_id __used i1480_est_id_table[] = {
 	{ USB_DEVICE(0x8086, 0xdf3b), },
 	{ USB_DEVICE(0x8086, 0x0c3b), },
 	{ },
-- 
1.7.0.4

