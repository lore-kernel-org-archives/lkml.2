Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab1DNR5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:41271 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616Ab1DNR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, andrew hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 115/209] memory corruption in X.25 facilities parsing
Date: Thu, 14 Apr 2011 13:54:33 -0400
Message-Id: <1302803767-9715-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: andrew hendry <andrew.hendry@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit a6331d6f9a4298173b413cf99a40cc86a9d92c37 upstream.

Signed-of-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/x25/x25_facilities.c |    8 ++++----
 net/x25/x25_in.c         |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/x25/x25_facilities.c b/net/x25/x25_facilities.c
index 771bab0..3a8c4c4 100644
--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -134,15 +134,15 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 		case X25_FAC_CLASS_D:
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->calling_len = p[2];
 				memcpy(dte_facs->calling_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLING_AE;
 				break;
 			case X25_FAC_CALLED_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->called_len = p[2];
 				memcpy(dte_facs->called_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLED_AE;
diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index 372ac22..3b67027 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -119,6 +119,8 @@ static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 						&x25->vc_facil_mask);
 			if (len > 0)
 				skb_pull(skb, len);
+			else
+				return -1;
 			/*
 			 *	Copy any Call User Data.
 			 */
-- 
1.7.4.4

