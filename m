Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2LDWVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:21:35 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:38198 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2LDWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:21:31 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] mv-otg: use to_delayed_work instead of cast
Date: Tue,  4 Dec 2012 20:21:12 -0200
Message-Id: <1354659672-3409-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly casting a work_struct pointer to a delayed_work is risky if the
work member of struct delayed_work is ever moved from being the first
member.

Instead, use the inline function to_delayed_work(), which does the same
cast in a safer way (using container_of).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 drivers/usb/otg/mv_otg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/otg/mv_otg.c b/drivers/usb/otg/mv_otg.c
index 3f124e8..156e1d9 100644
--- a/drivers/usb/otg/mv_otg.c
+++ b/drivers/usb/otg/mv_otg.c
@@ -420,7 +420,7 @@ static void mv_otg_work(struct work_struct *work)
 	struct usb_otg *otg;
 	int old_state;
 
-	mvotg = container_of((struct delayed_work *)work, struct mv_otg, work);
+	mvotg = container_of(to_delayed_work(work), struct mv_otg, work);
 
 run:
 	/* work queue is single thread, or we need spin_lock to protect */
-- 
1.7.11.7

