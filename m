Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2GLGMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:12:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54971 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab2GLGMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:12:33 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Devendra Naga <devendra.aaru@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging/gdm72xx: cleanup little at gdm_wimax_event_rcv
Date: Thu, 12 Jul 2012 11:57:25 +0545
Message-Id: <1342073545-12100-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the event sock check is done at the netlink_init itself.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/gdm_wimax.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index e616de1..0716efc 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -255,17 +255,15 @@ static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 
 static int gdm_wimax_event_init(void)
 {
-	if (wm_event.ref_cnt == 0) {
+	if (!wm_event.ref_cnt) {
 		wm_event.sock = netlink_init(NETLINK_WIMAX,
 						gdm_wimax_event_rcv);
+		if (wm_event.sock)
+			wm_event.ref_cnt++;
 		INIT_LIST_HEAD(&wm_event.evtq);
 		INIT_LIST_HEAD(&wm_event.freeq);
 		INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
 		spin_lock_init(&wm_event.evt_lock);
-	}
-
-	if (wm_event.sock) {
-		wm_event.ref_cnt++;
 		return 0;
 	}
 
-- 
1.7.9.5

