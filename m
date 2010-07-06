Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0GFVoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 17:44:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57577 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0GFVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 17:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:user-agent:date:message-id:mime-version
         :content-type;
        b=McUIC6uhCaHynJzTHcEYPLK2pPYe79WWrYgcrdkKPWyXmXEpfZMY314JVVknpqvtJr
         JpMhHkX60J3IwE+Y9qBk1K8f8VMwl2L0KxmeUJX2j5d0N0hOQUSQRaZ3N/iK6RG5zYw9
         eJ7fIIMHDxVdkwlAMJUApygsfBf2XcrjHTcT8=
From: George Kadianakis <desnacked@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ipv4/ip_output.c: Removal of unused variable in ip_fragment()
User-Agent: Microsoft Outlook Express 5.50.4522.1200
Date: Wed, 07 Jul 2010 00:44:12 +0300
Message-ID: <874ogctheb.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Kadianakis <desnacked@gmail.com>

Removal of unused integer variable in ip_fragment().

Signed-off-by: George Kadianakis <desnacked@gmail.com>
---
 net/ipv4/ip_output.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 041d41d..a83b876 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -442,7 +442,6 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 {
 	struct iphdr *iph;
-	int raw = 0;
 	int ptr;
 	struct net_device *dev;
 	struct sk_buff *skb2;
@@ -580,7 +579,7 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 
 slow_path:
 	left = skb->len - hlen;		/* Space per frame */
-	ptr = raw + hlen;		/* Where to start from */
+	ptr = hlen;		/* Where to start from */
 
 	/* for bridged IP traffic encapsulated inside f.e. a vlan header,
 	 * we need to make room for the encapsulating header
