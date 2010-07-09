Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0GIOrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:47:31 -0400
Received: from llsc494-a04.servidoresdns.net ([82.223.190.47]:49314 "EHLO
	llsc494-a04.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755699Ab0GIOra convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:47:30 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 10:47:30 EDT
From: Rodrigo Partearroyo =?iso-8859-1?q?Gonz=E1lez?= 
	<rpartearroyo@albentia.com>
Organization: Albentia Systems
To: Herbert Xu <herbert@gondor.hengli.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: net/sched/act_nat.c BUG
Date: Fri, 9 Jul 2010 16:37:56 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: Iratxo Pichel Ortiz <ipichel@albentia.com>,
       Noelia =?iso-8859-1?q?Mor=F3n?= <nmoron@albentia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007091637.57660.rpartearroyo@albentia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have been testing Stateless NAT and found that ICMP packets with length less 
than 20 bytes were not correctly NAT'ed. I have found a BUG that makes taking 
into account IP header length twice, so ICMP packets smaller than 20 bytes 
were being dropped.

The proposed fix is:

Index: net/sched/act_nat.c
===================================================================
--- net/sched/act_nat.c
+++ net/sched/act_nat.c
@@ -202,7 +202,7 @@
        {
                struct icmphdr *icmph;
 
-               if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
+               if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
                        goto drop;
 
                icmph = (void *)(skb_network_header(skb) + ihl);

Please, consider applying it.
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
