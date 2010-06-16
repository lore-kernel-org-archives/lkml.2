Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0FPFd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:33:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46517 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0FPFdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oQSm0BYIOsty+YWprEjH2YFTDCPIcyCnTRzbFTLpuieF69bx/dlWmWY8ekqfLdBHJU
         pMFnbW+mhNl9xqPJ1YcFoAv2moMa2iZ5UiXXI0o87xxQ1JhVKs+jNd2NQAw0BvpNyDFn
         CB7fk6PhkL7LpLSkhBB+1DzZwLhWsKUXifIzs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5]wireless:hostap_ap.c Fix warning: variable 'fc' set but not used
Date: Tue, 15 Jun 2010 22:33:51 -0700
Message-Id: <1276666434-11227-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a warning message when compiling with gcc 4.6.0
  CC [M]  drivers/net/wireless/hostap/hostap_ap.o
drivers/net/wireless/hostap/hostap_ap.c: In function 'hostap_ap_tx_cb_assoc':
drivers/net/wireless/hostap/hostap_ap.c:691:6: warning: variable 'fc' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_ap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 231dbd7..9cadaa2 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -688,7 +688,7 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 	struct ap_data *ap = data;
 	struct net_device *dev = ap->local->dev;
 	struct ieee80211_hdr *hdr;
-	u16 fc, status;
+	u16 status;
 	__le16 *pos;
 	struct sta_info *sta = NULL;
 	char *txt = NULL;
@@ -699,7 +699,6 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 	}
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
 	if ((!ieee80211_is_assoc_resp(hdr->frame_control) &&
 	     !ieee80211_is_reassoc_resp(hdr->frame_control)) ||
 	    skb->len < IEEE80211_MGMT_HDR_LEN + 4) {
-- 
1.7.1.rc1.21.gf3bd6

