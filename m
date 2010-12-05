Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0LERxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:53:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab0LERwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uuNp36PChfZWOkDL4AC58Sz/Yk3awJGxKc7wi7trjPoHuOxripK83X66dTGBbmPi0A
         ge2j3WnwydZ5TQGYkRItc2yS4mCVLArJovn4iA8oPtOU2l/G8x8QRRh2pA/d//p+wXOJ
         SgH1u1YK/mqQPGA9+FFzXnvsGZXq2Ukuq1aoA=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 40/45] kstrtox: convert drivers/ssb/
Date: Sun,  5 Dec 2010 19:49:37 +0200
Message-Id: <1291571382-2719-40-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
1.7.2.2

