Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2IDPMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:12:18 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:11976 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab2IDPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIw8BRhAgBQImAgJXBhOIEad7kmCBIZAMgRIDlVmJM4lM
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821826"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 13/16] Staging: ipack/devices/ipoctal: Expose DEVICE_TABLE for ipoctal.
Date: Tue,  4 Sep 2012 17:01:18 +0200
Message-Id: <1346770881-4723-14-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

The modalias entries for the module are now created.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 7e1e6f7..829b887 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -845,6 +845,18 @@ static void ipoctal_remove(struct ipack_device *device)
 	}
 }
 
+static DEFINE_IPACK_DEVICE_TABLE(ipoctal_ids) = {
+	{ IPACK_DEVICE(IPACK_ID_VERSION_1, IPACK1_VENDOR_ID_SBS,
+			IPACK1_DEVICE_ID_SBS_OCTAL_232) },
+	{ IPACK_DEVICE(IPACK_ID_VERSION_1, IPACK1_VENDOR_ID_SBS,
+			IPACK1_DEVICE_ID_SBS_OCTAL_422) },
+	{ IPACK_DEVICE(IPACK_ID_VERSION_1, IPACK1_VENDOR_ID_SBS,
+			IPACK1_DEVICE_ID_SBS_OCTAL_485) },
+	{ 0, },
+};
+
+MODULE_DEVICE_TABLE(ipack, ipoctal_ids);
+
 static const struct ipack_driver_ops ipoctal_drv_ops = {
 	.match = ipoctal_match,
 	.probe = ipoctal_probe,
@@ -853,6 +865,7 @@ static const struct ipack_driver_ops ipoctal_drv_ops = {
 
 static struct ipack_driver driver = {
 	.ops      = &ipoctal_drv_ops,
+	.id_table = ipoctal_ids,
 };
 
 static int __init ipoctal_init(void)
-- 
1.7.10.4

