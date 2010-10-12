Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab0JLPn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:43:27 -0400
Received: from mail.perches.com ([173.55.12.10]:2770 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab0JLPn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:43:26 -0400
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode
 in debugfs"
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
	 <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 08:43:24 -0700
Message-ID: <1286898204.1117.47.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 10:53 -0400, John W. Linville wrote:
> Without this and with CONFIG_ATH_DEBUG not set...
> ERROR: ".ath_opmode_to_string" [drivers/net/wireless/ath/ath5k/ath5k.ko] undefined!

Perhaps this instead?

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/debug.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index a3a5a62..5013045 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -78,6 +78,13 @@ ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 #endif /* CONFIG_ATH_DEBUG */
 
 /** Returns string describing opmode, or NULL if unknown mode. */
+#ifdef CONFIG_ATH_DEBUG
 const char *ath_opmode_to_string(enum nl80211_iftype opmode);
+#else
+static inline const char *ath_opmode_to_string(enum nl80211_iftype opmode)
+{
+	return NULL;
+}
+#endif
 
 #endif /* ATH_DEBUG_H */


