Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2FOFz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 01:55:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35686 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827Ab2FOFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 01:55:24 -0400
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 02/20] airo_cs: Use pr_<level>
Date: Thu, 14 Jun 2012 22:53:42 -0700
Message-Id: <2166780c7f792e05c57d84f3b9ddf63b14ffb37c.1339739416.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1339739415.git.joe@perches.com>
References: <cover.1339739415.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Convert printks to pr_<level>.
Convert printk(KERN_DEBUG to pr_debug(.
Coalesce formats, align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/airo_cs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index 630577d..1a723be 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -20,6 +20,8 @@
 
 ======================================================================*/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #ifdef __IN_PCMCIA_PACKAGE__
 #include <pcmcia/k_compat.h>
 #endif
@@ -70,7 +72,7 @@ static int airo_probe(struct pcmcia_device *p_dev)
 	/* Allocate space for private device-specific data */
 	local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
 	if (!local) {
-		printk(KERN_ERR "airo_cs: no memory for new device\n");
+		pr_err("no memory for new device\n");
 		return -ENOMEM;
 	}
 	p_dev->priv = local;
-- 
1.7.8.111.gad25c.dirty

