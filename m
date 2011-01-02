Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1ABHY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:36707 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1ABHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kumar Sanghvi <kumar.sanghvi@stericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 195/260] Phonet: Correct header retrieval after pskb_may_pull
Date: Sun,  2 Jan 2011 02:18:11 -0500
Message-Id: <1293952756-15010-196-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:23:44.0276 (UTC) FILETIME=[FCEC9D40:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Sanghvi <kumar.sanghvi@stericsson.com>

commit a91e7d471e2e384035b9746ea707ccdcd353f5dd upstream.

Retrieve the header after doing pskb_may_pull since, pskb_may_pull
could change the buffer structure.

This is based on the comment given by Eric Dumazet on Phonet
Pipe controller patch for a similar problem.

Signed-off-by: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/phonet/pep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index e2a9576..dc1e8ae 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -225,12 +225,13 @@ static void pipe_grant_credits(struct sock *sk)
 static int pipe_rcv_status(struct sock *sk, struct sk_buff *skb)
 {
 	struct pep_sock *pn = pep_sk(sk);
-	struct pnpipehdr *hdr = pnp_hdr(skb);
+	struct pnpipehdr *hdr;
 	int wake = 0;
 
 	if (!pskb_may_pull(skb, sizeof(*hdr) + 4))
 		return -EINVAL;
 
+	hdr = pnp_hdr(skb);
 	if (hdr->data[0] != PN_PEP_TYPE_COMMON) {
 		LIMIT_NETDEBUG(KERN_DEBUG"Phonet unknown PEP type: %u\n",
 				(unsigned)hdr->data[0]);
-- 
1.7.3.3

