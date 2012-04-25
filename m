Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2DYOuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:50:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43733 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DYOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:50:17 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tlan: add cast needed for proper 64 bit operation
Date: Wed, 25 Apr 2012 10:49:20 -0400
Message-Id: <1335365360-4891-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes this beauty into a statement that actually has an effect on amd64.

Tested-by: Per Jessen <per@opensuse.org>
Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 drivers/net/ethernet/ti/tlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 817ad3b..efd3669 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -228,7 +228,7 @@ tlan_get_skb(const struct tlan_list *tag)
 	unsigned long addr;
 
 	addr = tag->buffer[9].address;
-	addr |= (tag->buffer[8].address << 16) << 16;
+	addr |= ((unsigned long) tag->buffer[8].address << 16) << 16;
 	return (struct sk_buff *) addr;
 }
 
-- 
1.7.7

