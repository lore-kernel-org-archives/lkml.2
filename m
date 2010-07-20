Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708Ab0GTUnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:16 -0400
Received: from claw.goop.org ([74.207.240.146]:50938 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761597Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/16] xen/blkfront: avoid compiler warning from missing cases
Date: Tue, 20 Jul 2010 13:42:13 -0700
Message-Id: <d38663a058579a8eeff3b4525475aa82b04f2469.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Fix:
drivers/block/xen-blkfront.c: In function ‘blkfront_connect’:
drivers/block/xen-blkfront.c:933: warning: enumeration value ‘BLKIF_STATE_DISCONNECTED’ not handled in switch

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 0b4091b..3426704 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -947,6 +947,9 @@ static void blkfront_connect(struct blkfront_info *info)
 		/* fall through */
 	case BLKIF_STATE_SUSPENDED:
 		return;
+
+	default:
+		break;
 	}
 
 	dev_dbg(&info->xbdev->dev, "%s:%s.\n",
-- 
1.7.1.1

