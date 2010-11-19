Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0KSWDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:03:05 -0500
Received: from kroah.org ([198.145.64.141]:45377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602Ab0KSV67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:59 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215644.168170468@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kumar Sanghvi <kumar.sanghvi@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?ISO-8859-15?q?R=C3=A9mi=20Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [66/82] Phonet: Correct header retrieval after pskb_may_pull
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Kumar Sanghvi <kumar.sanghvi@stericsson.com>

[ Upstream commit a91e7d471e2e384035b9746ea707ccdcd353f5dd ]

Retrieve the header after doing pskb_may_pull since, pskb_may_pull
could change the buffer structure.

This is based on the comment given by Eric Dumazet on Phonet
Pipe controller patch for a similar problem.

Signed-off-by: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/phonet/pep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -225,12 +225,13 @@ static void pipe_grant_credits(struct so
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


