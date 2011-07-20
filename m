Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GTOae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:30:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52929 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1GTOab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:30:31 -0400
From: <pavan_savoy@ti.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
CC: pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/4] drivers:misc: ti-st: avoid a misleading dbg msg
Date: Wed, 20 Jul 2011 09:30:17 -0500
Message-ID: <1311172225-17678-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1311172225-17678-1-git-send-email-pavan_savoy@ti.com>
References: <1311172225-17678-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Previously the private data of each protocol registered to use ST was
used to determine whether the protocol was registered to use shared
transport or otherwise.
However, now a flag is_registered is maintained to identify whether a
protocol intends to use ST.
Upon closing of the UART the error message relevant to this lack of
un-registration was misleading and this patch fixes that.

Change-Id: Ieddf828c5fa9ceabcbf9346ebdfde797916ac1f3
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 54c91ff..c8e335d 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -717,7 +717,7 @@ static void st_tty_close(struct tty_struct *tty)
 	 */
 	spin_lock_irqsave(&st_gdata->lock, flags);
 	for (i = ST_BT; i < ST_MAX_CHANNELS; i++) {
-		if (st_gdata->list[i] != NULL)
+		if (st_gdata->is_registered[i] == true)
 			pr_err("%d not un-registered", i);
 		st_gdata->list[i] = NULL;
 	}
-- 
1.7.4.1

