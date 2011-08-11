Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1HKO2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:28:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1HKO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:27:55 -0400
Date: Thu, 11 Aug 2011 17:27:50 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: rdunlap@xenotime.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] SCSI: OSD: Kconfig: Select SHA1 and HMAC for OSD Initiator
 library
Message-ID: <20110811142749.GA26109@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCSI_OSD_INITIATOR should select CRYPTO_SHA1 and CRYPTO_HMAC. Express this
in Kconfig so that the requirements are met automatically. 

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
index 861b5ce..1535fe1 100644
--- a/drivers/scsi/osd/Kconfig
+++ b/drivers/scsi/osd/Kconfig
@@ -11,17 +11,16 @@
 # it under the terms of the GNU General Public version 2 License as
 # published by the Free Software Foundation
 #
-# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
-#        How is it done properly?
 #
 
 config SCSI_OSD_INITIATOR
 	tristate "OSD-Initiator library"
 	depends on SCSI
+	select CRYPTO
+	select CRYPTO_SHA1
+	select CRYPTO_HMAC
 	help
 		Enable the OSD-Initiator library (libosd.ko).
-		NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
-		dependencies
 
 config SCSI_OSD_ULD
 	tristate "OSD Upper Level driver"
