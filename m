Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1CWNiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:38:06 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:57169 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab1CWNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:38:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/3] Add a kstrtobool function matching semantics of existing in kernel equivalents.
Date: Wed, 23 Mar 2011 13:39:12 +0000
Message-Id: <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/kernel.h |    1 +
 lib/kstrtox.c          |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 00cec4d..0babad3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -247,6 +247,7 @@ int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
 int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
 int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
 int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
+int __must_check kstrtobool(const char *s, bool *res);
 
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 05672e8..84cf08f 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -225,4 +225,21 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
 	return 0;
 }
 EXPORT_SYMBOL(kstrtos8);
+
+int kstrtobool(const char *s, bool *res)
+{
+	switch (s[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		*res = true;
+	case 'n':
+	case 'N':
+	case '0':
+		*res = false;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(kstrtobool);
-- 
1.7.3.4

