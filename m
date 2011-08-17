Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1HQJXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab1HQJXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:23:50 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        WANG Cong <amwang@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 4/5] nbd: lower the loglevel of an error message
Date: Wed, 17 Aug 2011 17:22:42 +0800
Message-Id: <1313572963-3440-4-git-send-email-amwang@redhat.com>
In-Reply-To: <1313572963-3440-1-git-send-email-amwang@redhat.com>
References: <1313572963-3440-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>

This is only an error, no need to use KERN_CRIT log level.

Signed-off-by: WANG Cong <amwang@redhat.com>
---
 drivers/block/nbd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 1b8e09f..2b5fc11 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -745,7 +745,7 @@ static int __init nbd_init(void)
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
 	if (max_part < 0) {
-		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
+		printk(KERN_ERR "nbd: max_part must be >= 0\n");
 		return -EINVAL;
 	}
 
-- 
1.7.4.4

