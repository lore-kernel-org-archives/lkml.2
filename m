Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2DPPoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:44:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49603 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab2DPPoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:44:08 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Dan Williams <dcbw@redhat.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/wireless/libertas/if_usb.c: add missing debugging code
Date: Mon, 16 Apr 2012 17:44:00 +0200
Message-Id: <1334591040-29298-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add a corresponding leave call on error failure.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/libertas/if_usb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 74da5f1..ce4938d 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1128,8 +1128,10 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	if (priv->psstate != PS_STATE_FULL_POWER)
-		return -1;
+	if (priv->psstate != PS_STATE_FULL_POWER) {
+		ret = -1;
+		goto out;
+	}
 
 #ifdef CONFIG_OLPC
 	if (machine_is_olpc()) {

