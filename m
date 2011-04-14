Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1DNRpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:37455 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab1DNRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 021/209] irda: Fix heap memory corruption in iriap.c
Date: Thu, 14 Apr 2011 13:40:51 -0400
Message-Id: <1302803039-9400-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <samuel@sortiz.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 37f9fc452d138dfc4da2ee1ce5ae85094efc3606 upstream.

While parsing the GetValuebyClass command frame, we could potentially write
passed the skb->data pointer.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/iriap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index 79a1e5a..b6fd6d1 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -502,7 +502,8 @@ static void iriap_getvaluebyclass_confirm(struct iriap_cb *self,
 		IRDA_DEBUG(4, "%s(), strlen=%d\n", __func__, value_len);
 
 		/* Make sure the string is null-terminated */
-		fp[n+value_len] = 0x00;
+		if (n + value_len < skb->len)
+			fp[n + value_len] = 0x00;
 		IRDA_DEBUG(4, "Got string %s\n", fp+n);
 
 		/* Will truncate to IAS_MAX_STRING bytes */
-- 
1.7.4.4

