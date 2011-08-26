Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1HZUg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab1HZUeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/13] drivers:misc: ti-st: avoid a misleading dbg msg
Date: Fri, 26 Aug 2011 13:33:47 -0700
Message-Id: <1314390834-3411-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
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

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

