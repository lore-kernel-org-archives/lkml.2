Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2FKB67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 21:58:59 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:32557
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab2FKB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 21:58:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1202hzz8275bhz2dh2a8h668h839he5bhf0ah)
From: Liu Ying <Ying.Liu@freescale.com>
To: <g.liakhovetski@gmx.de>
CC: <liu.y.victor@gmail.com>, <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/3] mx3fb: do not support panning with fb blanked
Date: Mon, 11 Jun 2012 09:06:48 +0800
Message-ID: <1339376810-8247-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if framebuffer is unblanked before
we actually trigger panning in custom pan display
function.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/video/mx3fb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index e3406ab..d53db60 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1063,6 +1063,11 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 	dev_dbg(fbi->device, "%s [%c]\n", __func__,
 		list_empty(&mx3_fbi->idmac_channel->queue) ? '-' : '+');
 
+	if (mx3_fbi->blank != FB_BLANK_UNBLANK) {
+		dev_dbg(fbi->device, "panning with fb blanked not supported\n");
+		return -EFAULT;
+	}
+
 	if (var->xoffset > 0) {
 		dev_dbg(fbi->device, "x panning not supported\n");
 		return -EINVAL;
-- 
1.7.1


