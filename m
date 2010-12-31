Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0LaKfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:35:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40542 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0LaKfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GNydkxtpAXsB5dPqcX77S/Q3zCsuqsxd3r0a2JFaHNK7IDiFXusrgqcHnd/we6XYvT
         6pahReX1zCC5Snb53BWP4/PYQPLRspr5Jw4KIO+whhjuKw5IKHvJOxo27YzEl0hsONZJ
         7IHI+CoOxfNw/fn0wi2Aom+s+MAODgkty2IR4=
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 11:35:12 +0100
Message-ID: <1293791712.2973.38.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
écrit :
> 		/*
> +			 * set a flag for UDPCP message
> +			 */
> +			skb->cb[sizeof(struct udp_skb_cb)] = 1;


Dont do that. This hides an important thing : you use one extra byte in
skb->cb[] without being explicit.

As we have one byte hole in struct udp_skb_cbn, you could use it
instead.

diff --git a/include/net/udp.h b/include/net/udp.h
index bb967dd..ceafbbf 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -47,6 +47,7 @@ struct udp_skb_cb {
 	} header;
 	__u16		cscov;
 	__u8		partial_cov;
+	__u8		udpcp_flag;
 };
 #define UDP_SKB_CB(__skb)	((struct udp_skb_cb *)((__skb)->cb))
 


