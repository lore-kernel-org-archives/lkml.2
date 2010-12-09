Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0LIUIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:08:21 -0500
Received: from mail.perches.com ([173.55.12.10]:2397 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab0LIUEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:13 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 07/15] brcm80211: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:00 -0800
Message-Id: <91765bc9e7999d0e4dcbd83666962ee03f34ab63.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 0d7aa4a..edf300d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3196,7 +3196,7 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 	}
 	WL_DBG(("func %p\n", wl_cfg80211_get_sdio_func()));
 	wdev = wl_alloc_wdev(sizeof(struct wl_iface), &wl_cfg80211_get_sdio_func()->dev);
-	if (unlikely(IS_ERR(wdev)))
+	if (IS_ERR(wdev))
 		return -ENOMEM;
 
 	wdev->iftype = wl_mode_to_nl80211_iftype(WL_MODE_BSS);
-- 
1.7.3.3.464.gf80b6

