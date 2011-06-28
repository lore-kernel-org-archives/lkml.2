Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab1F1QEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:04:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51235 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab1F1QCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:02:13 -0400
X-Sasl-enc: TffUfHsYebQtxtip8XEPUdUtJILroppKzVI7379JPyPZ 1309276932
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Shahar Lev <shahar@wizery.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/9] drivers:misc: ti-st: fix skipping of change remote baud
Date: Tue, 28 Jun 2011 09:02:01 -0700
Message-Id: <1309276926-1327-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309276926-1327-1-git-send-email-gregkh@suse.de>
References: <20110628153911.GD32710@kroah.com>
 <1309276926-1327-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shahar Lev <shahar@wizery.com>

Before the incrementing of ptr in skip_change_remote_baud,
it points to cur_action, but the increment is done by
the size of nxt_action instead. This could cause ptr
to not point to a bts_action structure, which is
harmful for the increment of ptr done in download_firmware.
Therefore, the skipping is first done for cur_action.

Signed-off-by: Shahar Lev <shahar@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_kim.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 3613c3b..38fd2f0 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -245,9 +245,9 @@ void skip_change_remote_baud(unsigned char **ptr, long *len)
 		pr_err("invalid action after change remote baud command");
 	} else {
 		*ptr = *ptr + sizeof(struct bts_action) +
-			((struct bts_action *)nxt_action)->size;
+			((struct bts_action *)cur_action)->size;
 		*len = *len - (sizeof(struct bts_action) +
-				((struct bts_action *)nxt_action)->size);
+				((struct bts_action *)cur_action)->size);
 		/* warn user on not commenting these in firmware */
 		pr_warn("skipping the wait event of change remote baud");
 	}
-- 
1.7.5.4

