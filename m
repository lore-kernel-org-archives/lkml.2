Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1ENNnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 09:43:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50970 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab1ENNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 09:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v2n8m57jFBCBv62fF8QEfa6gW2bDPrR+sji6yT396QdCq6PDyfdeZD68fG1yctZOb1
         6V/vGMYXcTmZjz96xKwpwOS6mjqoPJAei/0YsVtvc9EIXFa72/i8dvsSXHwKRL4M2l52
         EyndT0HvzQS7tKxztBcsNHE8xfXfMq5Ii2vJg=
Date: Sat, 14 May 2011 16:43:07 +0300
From: Maxin B John <maxin.john@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kaber@trash.net, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, pekkas@netcore.fi, kuznet@ms2.inr.ac.ru,
        davem@davemloft.net
Subject: [PATCH] net: ipv6: mcast: Removing invalid check
Message-ID: <20110514134307.GA3603@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the variable 'first' is assigned to 1, the check
"if (truncate && !first)" will always be false.

Thanks to Coverity for spotting this issue.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 76b8937..441c1a4 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1536,8 +1536,6 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 		if (AVAILABLE(skb) < sizeof(*psrc) +
 		    first*sizeof(struct mld2_grec)) {
-			if (truncate && !first)
-				break;	 /* truncate these */
 			if (pgr)
 				pgr->grec_nsrcs = htons(scount);
 			if (skb)
