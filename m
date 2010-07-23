Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab0GWNTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:19:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54478 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab0GWNSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v8bQScLLiZCvTNtiGaTFWfHDws/gfZHntKtHfFLHoQ1N6i8ksBa0HvqL4n62ZDxTD7
         xOxBjSMvxKABNWc4Bli6r/4BX8KMYq+R8N+JFCWXuRbq7up8i09N81maMJBxdF6/qOPs
         65evfq7z3ZU8IW5InvyrdBBSrcKSXVKa5HGeQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5/5] net: core: don't use own hex_to_bin() method
Date: Fri, 23 Jul 2010 16:18:10 +0300
Message-Id: <2519848e90eac1857ff7a8399e118980dd0bfbd0.1279890832.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279890832.git.andy.shevchenko@gmail.com>
References: <cover.1279890832.git.andy.shevchenko@gmail.com>
In-Reply-To: <cover.1279890832.git.andy.shevchenko@gmail.com>
References: <cover.1279890832.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 net/core/pktgen.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 24a19de..10a1ea7 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1434,18 +1434,12 @@ static ssize_t pktgen_if_write(struct file *file,
 		i += len;
 
 		for (*m = 0; *v && m < pkt_dev->dst_mac + 6; v++) {
-			if (*v >= '0' && *v <= '9') {
-				*m *= 16;
-				*m += *v - '0';
-			}
-			if (*v >= 'A' && *v <= 'F') {
-				*m *= 16;
-				*m += *v - 'A' + 10;
-			}
-			if (*v >= 'a' && *v <= 'f') {
-				*m *= 16;
-				*m += *v - 'a' + 10;
-			}
+			int value;
+
+			value = hex_to_bin(*v);
+			if (value >= 0)
+				*m = *m * 16 + value;
+
 			if (*v == ':') {
 				m++;
 				*m = 0;
@@ -1476,18 +1470,12 @@ static ssize_t pktgen_if_write(struct file *file,
 		i += len;
 
 		for (*m = 0; *v && m < pkt_dev->src_mac + 6; v++) {
-			if (*v >= '0' && *v <= '9') {
-				*m *= 16;
-				*m += *v - '0';
-			}
-			if (*v >= 'A' && *v <= 'F') {
-				*m *= 16;
-				*m += *v - 'A' + 10;
-			}
-			if (*v >= 'a' && *v <= 'f') {
-				*m *= 16;
-				*m += *v - 'a' + 10;
-			}
+			int value;
+
+			value = hex_to_bin(*v);
+			if (value >= 0)
+				*m = *m * 16 + value;
+
 			if (*v == ':') {
 				m++;
 				*m = 0;
-- 
1.7.1.1

