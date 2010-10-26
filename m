Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab0JZCov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:44:51 -0400
Received: from mail.perches.com ([173.55.12.10]:3567 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab0JZCof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] drivers/video/msm/mddi.c: Remove multiple KERN_<level> uses
Date: Mon, 25 Oct 2010 19:44:27 -0700
Message-Id: <f1dbb5d550e2146508541335999374cf8910ff59.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/msm/mddi.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index 7c316c3..b66d86a 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -318,7 +318,7 @@ static long mddi_wait_interrupt_timeout(struct mddi_info *mddi,
 static void mddi_wait_interrupt(struct mddi_info *mddi, uint32_t intmask)
 {
 	if (mddi_wait_interrupt_timeout(mddi, intmask, HZ/10) == 0)
-		printk(KERN_INFO KERN_ERR "mddi_wait_interrupt %d, timeout "
+		printk(KERN_INFO "mddi_wait_interrupt %d, timeout "
 		       "waiting for %x, INT = %x, STAT = %x gotint = %x\n",
 		       current->pid, intmask, mddi_readl(INT), mddi_readl(STAT),
 		       mddi->got_int);
@@ -465,8 +465,7 @@ static int __init mddi_get_client_caps(struct mddi_info *mddi)
 
 		if (mddi->flags & FLAG_HAVE_CAPS)
 			break;
-		printk(KERN_INFO KERN_ERR "mddi_init, timeout waiting for "
-				"caps\n");
+		printk(KERN_INFO "mddi_init, timeout waiting for caps\n");
 	}
 	return mddi->flags & FLAG_HAVE_CAPS;
 }
-- 
1.7.3.dirty

