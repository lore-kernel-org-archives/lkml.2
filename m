Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab2EHPzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:55:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62138 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab2EHPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:55:37 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: kay@vrfy.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        isdn@linux-pingi.de, akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 4/4] ISDN: add missing KERN_CONT
Date: Tue,  8 May 2012 17:56:13 +0200
Message-Id: <1336492573-17530-4-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
References: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent this behaviour:

ISDN subsystem Rev: 1.1.2.3/
1.1.2.2/
1.1.2.3/
1.1.2.2/
1.1.2.2

Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/isdn/i4l/isdn_common.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 8c610fa..a75241c 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -2351,18 +2351,18 @@ static int __init isdn_init(void)
 	strcpy(tmprev, isdn_revision);
 	printk(KERN_NOTICE "ISDN subsystem Rev: %s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_net_revision);
-	printk("%s/", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_ppp_revision);
-	printk("%s/", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_audio_revision);
-	printk("%s/", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s/", isdn_getrev(tmprev));
 	strcpy(tmprev, isdn_v110_revision);
-	printk("%s", isdn_getrev(tmprev));
+	printk(KERN_CONT "%s", isdn_getrev(tmprev));
 
 #ifdef MODULE
-	printk(" loaded\n");
+	printk(KERN_CONT " loaded\n");
 #else
-	printk("\n");
+	printk(KERN_CONG "\n");
 #endif
 	isdn_info_update();
 	return 0;
-- 
1.7.8.5

