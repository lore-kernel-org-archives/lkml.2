Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773Ab0GTUpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:45:50 -0400
Received: from claw.goop.org ([74.207.240.146]:50931 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761590Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        "K. Y. Srinivasan" <ksrinivasan@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/16] xen/blkfront: revalidate after setting capacity
Date: Tue, 20 Jul 2010 13:42:14 -0700
Message-Id: <61e7470b763747248904ed9c54908eb306d4db07.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K. Y. Srinivasan <ksrinivasan@novell.com>

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3426704..50b2952 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -943,6 +943,7 @@ static void blkfront_connect(struct blkfront_info *info)
 		printk(KERN_INFO "Setting capacity to %Lu\n",
 		       sectors);
 		set_capacity(info->gd, sectors);
+		revalidate_disk(info->gd);
 
 		/* fall through */
 	case BLKIF_STATE_SUSPENDED:
-- 
1.7.1.1

