Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab0GIRTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:19:32 -0400
Received: from llsd409-a04.servidoresdns.net ([82.223.190.34]:48868 "EHLO
	llsd409-a04.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757041Ab0GIRTb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:19:31 -0400
From: Rodrigo Partearroyo =?iso-8859-1?q?Gonz=E1lez?= 
	<rpartearroyo@albentia.com>
Organization: Albentia Systems
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Subject: Re: [PATCH 001/001] QoS and/or fair queueing: Stateless NAT BUG
Date: Fri, 9 Jul 2010 19:19:21 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: "Herbert Xu" <herbert@gondor.hengli.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Iratxo Pichel Ortiz" <ipichel@albentia.com>,
       Noelia =?iso-8859-1?q?Mor=F3n?= <nmoron@albentia.com>,
       "netdev" <netdev@vger.kernel.org>
References: <25524.83.175.223.254.1278693359.squirrel@mail.albentia.com>
In-Reply-To: <25524.83.175.223.254.1278693359.squirrel@mail.albentia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007091919.22524.rpartearroyo@albentia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like the mailer corrupted the patch. Sorry, I resend it.
Thanks Eric.

On Viernes, 9 de Julio de 2010 18:35:59 rpartearroyo@albentia.com escribió:
> Hi all,
> I have been testing Stateless NAT and found that ICMP packets with length
> less than 20 bytes were not correctly NAT'ed. I have found a BUG that
> makes taking into account IP header length twice, so ICMP packets smaller
> than 20 bytes were being dropped.
> 
> Proposed formal patch is below, as suggested by Eric Dumazet, thanks.
> It is taken from 2.6.34.1 stable version.
> 
Signed-off-by: Rodrigo Partearroyo González <rpartearroyo@albentia.com>
---
diff -uprN a/net/sched/act_nat.c b/net/sched/act_nat.c
--- a/net/sched/act_nat.c	2010-07-09 18:25:18.000000000 +0200
+++ b/net/sched/act_nat.c	2010-07-09 18:26:16.000000000 +0200
@@ -202,7 +202,7 @@ static int tcf_nat(struct sk_buff *skb, 
 	{
 		struct icmphdr *icmph;
 
-		if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
+		if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
 			goto drop;
 
 		icmph = (void *)(skb_network_header(skb) + ihl);
@@ -223,7 +223,7 @@ static int tcf_nat(struct sk_buff *skb, 
 
 		if (skb_cloned(skb) &&
 		    !skb_clone_writable(skb,
-					ihl + sizeof(*icmph) + sizeof(*iph)) &&
+					ihl + sizeof(*icmph) ) &&
 		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
 			goto drop;
---

-- 
Rodrigo Partearroyo González
R&D Engineer

Albentia Systems S.A.
http://www.albentia.com
+34 914400213

C\Margarita Salas 22
Parque Tecnológico de Leganés
Leganés (28918)
Madrid
Spain
