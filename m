Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1BEOWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1BEOWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Deba3aOy5VRYi2iWDc2q//nFMUTZzXIy4DcQEZeTfnGyKcyjwbHAOzLzOEIBtcqOU6
         axuelWDxZSEYFsrtipeJt3Up0aYt3JrXV27pX4iAGqZvAUAj0Pvs/AvkRFI+xMsLGYzz
         iFPVGs2mBRKDS4Kd+M/vi/uy5suXtZ7VRCrdM=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 38/52] kstrtox: convert drivers/ssb/
Date: Sat,  5 Feb 2011 16:20:41 +0200
Message-Id: <1296915654-7458-38-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/ssb/sprom.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
index 4f7cc8d..fea2ac4 100644
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -38,7 +38,6 @@ static int hex2sprom(u16 *sprom, const char *dump, size_t len,
 {
 	char c, tmp[5] = { 0 };
 	int err, cnt = 0;
-	unsigned long parsed;
 
 	/* Strip whitespace at the end. */
 	while (len) {
@@ -52,12 +51,14 @@ static int hex2sprom(u16 *sprom, const char *dump, size_t len,
 		return -EINVAL;
 
 	while (cnt < sprom_size_words) {
+		u16 parsed;
+
 		memcpy(tmp, dump, 4);
 		dump += 4;
-		err = strict_strtoul(tmp, 16, &parsed);
+		err = kstrtou16(tmp, 16, &parsed);
 		if (err)
 			return err;
-		sprom[cnt++] = swab16((u16)parsed);
+		sprom[cnt++] = swab16(parsed);
 	}
 
 	return 0;
-- 
1.7.3.4

