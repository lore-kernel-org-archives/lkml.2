Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0DZTbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:31:18 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51620 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 09/19] staging:iio: Documentation, update iio_utils.h for the move to a bus
Date: Mon, 26 Apr 2010 20:31:11 +0100
Message-Id: <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/Documentation/iio_utils.h |   31 ++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index 74d3124..d24006a 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -47,7 +47,7 @@ inline char *find_ring_subelement(const char *directory, const char *subelement)
 
 char *find_type_by_name(const char *name, const char *type)
 {
-	const char *iio_dir = "/sys/class/iio/";
+	const char *iio_dir = "/sys/bus/iio/devices/";
 	const struct dirent *ent;
 	int cnt, pos, pos2;
 
@@ -112,6 +112,35 @@ int write_sysfs_int(char *filename, char *basedir, int val)
 	return 0;
 }
 
+int write_sysfs_int_and_verify(char *filename, char *basedir, int val)
+{
+	int ret;
+	FILE  *sysfsfp;
+	char temp[100];
+	int test;
+
+	sprintf(temp, "%s%s", basedir, filename);
+	sysfsfp = fopen(temp, "w");
+	if (sysfsfp == NULL)
+		return -1;
+	fprintf(sysfsfp, "%d", val);
+	fclose(sysfsfp);
+
+	sysfsfp = fopen(temp, "r");
+	if (sysfsfp == NULL)
+		return -1;
+	fscanf(sysfsfp, "%d", &test);
+	if (test != val) {
+		printf("Possible failure in int write %d to %s%s\n",
+		       val,
+		       basedir,
+		       filename);
+		return -1;
+	}
+
+	return 0;
+}
+
 /**
  * write_sysfs_string_and_verify() - string write, readback and verify
  * @filename: name of file to write to
-- 
1.6.4.4

