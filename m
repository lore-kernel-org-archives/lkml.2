Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2LVVHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 16:07:23 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:56957 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2LVVHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 16:07:18 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Piotr Haber <phaber@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] brcmsmac: initialize morepending in brcms_b_recv()
Date: Sat, 22 Dec 2012 22:07:14 +0100
Message-Id: <1356210434-28435-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/wireless/brcm80211/brcmsmac/main.c: In function ‘brcms_b_recv’:
drivers/net/wireless/brcm80211/brcmsmac/main.c:7636: warning: ‘morepending’ may be used uninitialized in this function

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 17594de..5f0f444 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7633,7 +7633,7 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
-	bool morepending;
+	bool morepending = false;
 
 	skb_queue_head_init(&recv_frames);
 
-- 
1.7.0.4

