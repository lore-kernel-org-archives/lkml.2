Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1HZUen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab1HZUej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/13] drivers:misc: ti-st: fix unexpected UART close
Date: Fri, 26 Aug 2011 13:33:54 -0700
Message-Id: <1314390834-3411-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

If suppose the UIM were to die and hence UART were to close when the
Bluetooth/FM or GPS is turned on, prep the ST for a state where-in if
the UIM comes back up, Bluetooth/FM/GPS can be turned on.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 1f973ce..ba168a7 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -727,6 +727,7 @@ static void st_tty_close(struct tty_struct *tty)
 		if (st_gdata->is_registered[i] == true)
 			pr_err("%d not un-registered", i);
 		st_gdata->list[i] = NULL;
+		st_gdata->is_registered[i] = false;
 	}
 	st_gdata->protos_registered = 0;
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
-- 
1.7.6.1

