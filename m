Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0JYVmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:42:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37182 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752674Ab0JYVmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:42:05 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX19YTptdEYVYOm1bWRs/bqHzVaz4pMkK6n6RNNXBMT
	TVRBHKNrGF+e0T
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: sven.eckelmann@gmx.de, andy.shevchenko@gmail.com, gregkh@suse.de
Subject: [PATCH] Staging: batman-adv: Remove useless braces
Date: Mon, 25 Oct 2010 23:43:14 +0200
Message-Id: <1288042994-27761-1-git-send-email-sven.eckelmann@gmx.de>
X-Mailer: git-send-email 1.7.2.3
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

77099f0afe94928b5b0066a7efa5fa9f81696b54 added changes to vis.c which
trigger a checkpatch.pl warning about braces which are not necessary
anymore.

WARNING: braces {} are not necessary for any arm of this statement
+               if (entry->primary)
[...]
+               else {
[...]

Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/staging/batman-adv/vis.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/batman-adv/vis.c b/drivers/staging/batman-adv/vis.c
index 3d2c1bc..4473cc8 100644
--- a/drivers/staging/batman-adv/vis.c
+++ b/drivers/staging/batman-adv/vis.c
@@ -135,9 +135,8 @@ static ssize_t vis_data_read_prim_sec(char *buff, struct hlist_head *if_list)
 	hlist_for_each_entry(entry, pos, if_list, list) {
 		if (entry->primary)
 			len += sprintf(buff + len, "PRIMARY, ");
-		else {
+		else
 			len += sprintf(buff + len,  "SEC %pM, ", entry->addr);
-		}
 	}
 
 	return len;
-- 
1.7.2.3

