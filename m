Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1JDOx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:53:59 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:44314 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab1JDOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:53:58 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: greg@kroah.com, sfr@canb.auug.org.au
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH] staging;iio: if(__LITTLE_ENDIAN) -> #ifdef __LITTLE_ENDIAN
Date: Tue,  4 Oct 2011 16:02:08 +0100
Message-Id: <1317740528-23110-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E8AC89C.7010409@cam.ac.uk>
References: <4E8AC89C.7010409@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsuprisingly this symbol isn't defined on big endian systems.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---

Sorry about this one.  Stupid mistake and I didn't have a cross compiler
for anything big endian set up.  Now I do. This time build tested on
arm, x86-64 and 32bit powerpc.

 drivers/staging/iio/industrialio-buffer.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/industrialio-buffer.c b/drivers/staging/iio/industrialio-buffer.c
index 4ce101a..60929ff 100644
--- a/drivers/staging/iio/industrialio-buffer.c
+++ b/drivers/staging/iio/industrialio-buffer.c
@@ -104,10 +104,11 @@ static ssize_t iio_show_fixed_type(struct device *dev,
 	u8 type = this_attr->c->scan_type.endianness;
 
 	if (type == IIO_CPU) {
-		if (__LITTLE_ENDIAN)
-			type = IIO_LE;
-		else
-			type = IIO_BE;
+#ifdef __LITTLE_ENDIAN
+		type = IIO_LE;
+#else
+		type = IIO_BE;
+#endif
 	}
 	return sprintf(buf, "%s:%c%d/%d>>%u\n",
 		       iio_endian_prefix[type],
-- 
1.7.3.4

