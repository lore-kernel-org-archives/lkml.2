Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1G0WBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:01:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:50745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab1G0Vs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826431"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: fernando@oss.ntt.co.jp, pablo@netfilter.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [59/99] netfilter: IPv6: fix DSCP mangle code
Message-Id: <20110727214858.5FECE2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

commit 1ed2f73d90fb49bcf5704aee7e9084adb882bfc5 upstream.

The mask indicates the bits one wants to zero out, so it needs to be
inverted before applying to the original TOS field.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/netfilter/xt_DSCP.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/net/netfilter/xt_DSCP.c
===================================================================
--- linux-2.6.35.y.orig/net/netfilter/xt_DSCP.c
+++ linux-2.6.35.y/net/netfilter/xt_DSCP.c
@@ -99,7 +99,7 @@ tos_tg6(struct sk_buff *skb, const struc
 	u_int8_t orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
