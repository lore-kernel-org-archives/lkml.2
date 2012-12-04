Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2LDBvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:51:05 -0500
Received: from dupo.coraid.com ([208.71.232.133]:57953 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260Ab2LDBvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:51:03 -0500
Message-Id: <79c6abb7070a7f8764a1391b690c2e7a8bd1fd5d.1354501189.git.ecashin@coraid.com>
In-Reply-To: <cover.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 6/7] aoe: identify source of runt AoE packets
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 3 Dec 2012 20:50:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change only affects experimental AoE storage networks.

It modifies the console message about runt packets detected so
that the AoE major and minor addresses of the AoE target that
generated the runt are mentioned.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index abf4ad2..25ef5c0 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1217,8 +1217,10 @@ noskb:		if (buf)
 	case ATA_CMD_PIO_READ:
 	case ATA_CMD_PIO_READ_EXT:
 		if (skb->len < n) {
-			pr_err("aoe: runt data size in read.  skb->len=%d need=%ld\n",
-				skb->len, n);
+			pr_err("%s e%ld.%d.  skb->len=%d need=%ld\n",
+				"aoe: runt data size in read from",
+				(long) d->aoemajor, d->aoeminor,
+			       skb->len, n);
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
@@ -1233,7 +1235,9 @@ noskb:		if (buf)
 		break;
 	case ATA_CMD_ID_ATA:
 		if (skb->len < 512) {
-			pr_info("aoe: runt data size in ataid.  skb->len=%d\n",
+			pr_info("%s e%ld.%d.  skb->len=%d need=512\n",
+				"aoe: runt data size in ataid from",
+				(long) d->aoemajor, d->aoeminor,
 				skb->len);
 			break;
 		}
-- 
1.7.1

