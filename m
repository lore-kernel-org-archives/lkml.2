Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0INEY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:24:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1994 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0INEYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mika Kuoppala <miku@iki.fi>, netdev@vger.kernel.org
Subject: [PATCH next 07/16] drivers/net: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:53 -0700
Message-Id: <e9a63f994c687a3155ee53349c55241d1622eacd.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/3c515.c  |    4 +++-
 drivers/net/eth16i.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/3c515.c b/drivers/net/3c515.c
index 8a6eb0c..cdf7226 100644
--- a/drivers/net/3c515.c
+++ b/drivers/net/3c515.c
@@ -662,7 +662,9 @@ static int corkscrew_setup(struct net_device *dev, int ioaddr,
 		pr_warning(" *** Warning: this IRQ is unlikely to work! ***\n");
 
 	{
-		char *ram_split[] = { "5:3", "3:1", "1:1", "3:5" };
+		static const char * const ram_split[] = {
+			"5:3", "3:1", "1:1", "3:5"
+		};
 		__u32 config;
 		EL3WINDOW(3);
 		vp->available_media = inw(ioaddr + Wn3_Options);
diff --git a/drivers/net/eth16i.c b/drivers/net/eth16i.c
index 10e39f2..ce22e15 100644
--- a/drivers/net/eth16i.c
+++ b/drivers/net/eth16i.c
@@ -637,7 +637,9 @@ static void eth16i_initialize(struct net_device *dev, int boot)
 
 	/* Set interface port type */
 	if(boot) {
-		char *porttype[] = {"BNC", "DIX", "TP", "AUTO", "FROM_EPROM" };
+		static const char * const porttype[] = {
+			"BNC", "DIX", "TP", "AUTO", "FROM_EPROM"
+		};
 
 		switch(dev->if_port)
 		{
-- 
1.7.3.rc1

