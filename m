Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1FPHMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:12:21 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43965 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932092Ab1FPHLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:42 -0400
X-Sasl-enc: iCt5GlN1U7R8pgmavcVCa1itYKnK8hwUjQeDeLJGdM2m 1308208301
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:12 2011
Message-Id: <20110616002912.280977772@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [84/85] netfilter: IPv6: fix DSCP mangle code
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

commit 1ed2f73d90fb49bcf5704aee7e9084adb882bfc5 upstream.

The mask indicates the bits one wants to zero out, so it needs to be
inverted before applying to the original TOS field.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_DSCP.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -99,7 +99,7 @@ tos_tg6(struct sk_buff *skb, const struc
 	u_int8_t orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))


