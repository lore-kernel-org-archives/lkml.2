Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1HITmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:42:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53979 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1HITjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:15 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 8/8] drivers:misc: ti-st: fix unexpected UART close
Date: Tue, 9 Aug 2011 14:39:00 -0500
Message-ID: <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

If suppose the UIM were to die and hence UART were to close when the
Bluetooth/FM or GPS is turned on, prep the ST for a state where-in if
the UIM comes back up, Bluetooth/FM/GPS can be turned on.

Change-Id: If3a0f100c69d485c343e189c4a483db26961b6b7
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
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
1.7.4.1

