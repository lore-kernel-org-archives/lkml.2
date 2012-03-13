Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab2CMBDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:03:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:47412 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab2CMAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 048/196] gro: reset skb_iif on reuse
Date: Mon, 12 Mar 2012 20:19:21 -0400
Message-Id: <1331598109-31424-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Gospodarek <andy@greyhouse.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6d152e23ad1a7a5b40fef1f42e017d66e6115159 upstream.

Like Herbert's change from a few days ago:

66c46d741e2e60f0e8b625b80edb0ab820c46d7a gro: Reset dev pointer on reuse

this may not be necessary at this point, but we should still clean up
the skb->skb_iif.  If not we may end up with an invalid valid for
skb->skb_iif when the skb is reused and the check is done in
__netif_receive_skb.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 19a74f6..1bde8b7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2823,6 +2823,7 @@ void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
 	skb->dev = napi->dev;
+	skb->skb_iif = 0;
 
 	napi->skb = skb;
 }
-- 
1.7.9.3

