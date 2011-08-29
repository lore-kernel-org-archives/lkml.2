Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1H2VWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:22:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38244 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754500Ab1H2VWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:22:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 21/24] wanrouter: Remove unnecessary OOM logging messages
Date: Mon, 29 Aug 2011 14:17:40 -0700
Message-Id: <164670c700d9d0a5f863c7c6c6947e8718cc605e.1314650069.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1314650069.git.joe@perches.com>
References: <cover.1314650069.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unnecessary messages saves code and text.

Site specific OOM messages are duplications of a generic MM
out of memory message and aren't really useful, so just
delete them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/wanrouter/wanmain.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 788a12c..01d0be4 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -437,11 +437,8 @@ static int wanrouter_device_setup(struct wan_device *wandev,
 	}
 
 	conf = kmalloc(sizeof(wandev_conf_t), GFP_KERNEL);
-	if (conf == NULL){
-		printk(KERN_INFO "%s: ERROR, Failed to allocate kernel memory !\n",
-				wandev->name);
+	if (conf == NULL)
 		return -ENOBUFS;
-	}
 
 	if (copy_from_user(conf, u_conf, sizeof(wandev_conf_t))) {
 		printk(KERN_INFO "%s: Failed to copy user config data to kernel space!\n",
@@ -468,9 +465,6 @@ static int wanrouter_device_setup(struct wan_device *wandev,
 
 		data = vmalloc(conf->data_size);
 		if (!data) {
-			printk(KERN_INFO
-				"%s: ERROR, Failed allocate kernel memory !\n",
-				wandev->name);
 			kfree(conf);
 			return -ENOBUFS;
 		}
-- 
1.7.6.405.gc1be0

