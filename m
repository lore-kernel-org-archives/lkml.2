Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1KVHme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:42:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39736 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1KVHmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:42:32 -0500
Message-ID: <1321947740.2476.0.camel@phoenix>
Subject: [PATCH] bbc_i2c: Remove unneeded err variable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Date: Tue, 22 Nov 2011 15:42:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/sbus/char/bbc_i2c.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 5f94d22..a0d1399 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -233,13 +233,9 @@ int bbc_i2c_write_buf(struct bbc_i2c_client *client,
 	int ret = 0;
 
 	while (len > 0) {
-		int err = bbc_i2c_writeb(client, *buf, off);
-
-		if (err < 0) {
-			ret = err;
+		ret = bbc_i2c_writeb(client, *buf, off);
+		if (ret < 0)
 			break;
-		}
-
 		len--;
 		buf++;
 		off++;
@@ -253,11 +249,9 @@ int bbc_i2c_read_buf(struct bbc_i2c_client *client,
 	int ret = 0;
 
 	while (len > 0) {
-		int err = bbc_i2c_readb(client, buf, off);
-		if (err < 0) {
-			ret = err;
+		ret = bbc_i2c_readb(client, buf, off);
+		if (ret < 0)
 			break;
-		}
 		len--;
 		buf++;
 		off++;
-- 
1.7.5.4



