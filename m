Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab2EOC7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:59:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:49476 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab2EOCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 071/179] netfilter: IPv6: fix DSCP mangle code
Date: Mon, 14 May 2012 22:12:47 -0400
Message-ID: <1337048075-6132-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1ed2f73d90fb49bcf5704aee7e9084adb882bfc5 upstream.

The mask indicates the bits one wants to zero out, so it needs to be
inverted before applying to the original TOS field.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/netfilter/xt_DSCP.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 74ce892..5ec6374 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -99,7 +99,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	u_int8_t orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
-- 
1.7.9.6

