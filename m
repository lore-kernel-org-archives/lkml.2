Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0JVXys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0JVXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LfPsa4uzHTLG5ocQ9Ho7+c7JNsAK4LgbbePHGEbpQoRm1A/wUk+K3c7XlaeJBe2duw
         9yCJZ3BsPRIZwwOoAZ4KzWOzmPHKdyMXKMpGvc1Vh4uq2tCLYIMSu1ITpN2qTkr9X/Tu
         2ET+e14OuW4vy7BAPOxj9wAJiI78v5WsxOt/c=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 17/29] memstick: jmb38x_ms: move "reg_data" functions together.
Date: Sat, 23 Oct 2010 01:53:45 +0200
Message-Id: <1287791637-10329-18-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, just group these funtions together.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  104 ++++++++++++++++++------------------
 drivers/memstick/host/jmb38x_ms.h |    8 +++
 2 files changed, 60 insertions(+), 52 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index e896a4d..2e10104 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -60,32 +60,6 @@ static unsigned int j38ms_read_data(struct j38ms_host *host,
 	return off;
 }
 
-static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
-					    unsigned char *buf,
-					    unsigned int length)
-{
-	unsigned int off = 0;
-
-	while (host->io_pos > 4 && length) {
-		buf[off++] = host->io_word[0] & 0xff;
-		host->io_word[0] >>= 8;
-		length--;
-		host->io_pos--;
-	}
-
-	if (!length)
-		return off;
-
-	while (host->io_pos && length) {
-		buf[off++] = host->io_word[1] & 0xff;
-		host->io_word[1] >>= 8;
-		length--;
-		host->io_pos--;
-	}
-
-	return off;
-}
-
 static unsigned int j38ms_write_data(struct j38ms_host *host,
 					 unsigned char *buf,
 					 unsigned int length)
@@ -139,32 +113,6 @@ static unsigned int j38ms_write_data(struct j38ms_host *host,
 	return off;
 }
 
-static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
-					     unsigned char *buf,
-					     unsigned int length)
-{
-	unsigned int off = 0;
-
-	while (host->io_pos < 4 && length) {
-		host->io_word[0] &= ~(0xff << (host->io_pos * 8));
-		host->io_word[0] |=  buf[off++] << (host->io_pos * 8);
-		host->io_pos++;
-		length--;
-	}
-
-	if (!length)
-		return off;
-
-	while (host->io_pos < 8 && length) {
-		host->io_word[1] &= ~(0xff << (host->io_pos * 8));
-		host->io_word[1] |=  buf[off++] << (host->io_pos * 8);
-		host->io_pos++;
-		length--;
-	}
-
-	return off;
-}
-
 static int j38ms_transfer_data(struct j38ms_host *host)
 {
 	unsigned int length;
@@ -232,6 +180,58 @@ static int j38ms_transfer_data(struct j38ms_host *host)
 	return length;
 }
 
+static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
+					    unsigned char *buf,
+					    unsigned int length)
+{
+	unsigned int off = 0;
+
+	while (host->io_pos > 4 && length) {
+		buf[off++] = host->io_word[0] & 0xff;
+		host->io_word[0] >>= 8;
+		length--;
+		host->io_pos--;
+	}
+
+	if (!length)
+		return off;
+
+	while (host->io_pos && length) {
+		buf[off++] = host->io_word[1] & 0xff;
+		host->io_word[1] >>= 8;
+		length--;
+		host->io_pos--;
+	}
+
+	return off;
+}
+
+static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
+					     unsigned char *buf,
+					     unsigned int length)
+{
+	unsigned int off = 0;
+
+	while (host->io_pos < 4 && length) {
+		host->io_word[0] &= ~(0xff << (host->io_pos * 8));
+		host->io_word[0] |=  buf[off++] << (host->io_pos * 8);
+		host->io_pos++;
+		length--;
+	}
+
+	if (!length)
+		return off;
+
+	while (host->io_pos < 8 && length) {
+		host->io_word[1] &= ~(0xff << (host->io_pos * 8));
+		host->io_word[1] |=  buf[off++] << (host->io_pos * 8);
+		host->io_pos++;
+		length--;
+	}
+
+	return off;
+}
+
 static int j38ms_issue_cmd(struct memstick_host *msh)
 {
 	struct j38ms_host *host = memstick_priv(msh);
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index c64f2e1..a940b5d 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -186,3 +186,11 @@ enum {
 #define dbg(host, format, ...)		__dbg(host, 1, format, ## __VA_ARGS__)
 #define dbg_v(host, format, ...)	__dbg(host, 2, format, ## __VA_ARGS__)
 #define dbg_reg(host, format, ...)	__dbg(host, 3, format, ## __VA_ARGS__)
+
+static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
+					    unsigned char *buf,
+					    unsigned int length);
+
+static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
+					     unsigned char *buf,
+					     unsigned int length);
-- 
1.7.1

