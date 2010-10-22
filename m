Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0JVSir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:47 -0400
Received: from kroah.org ([198.145.64.141]:45780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733Ab0JVSio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:59 2010
Message-Id: <20101022183559.590258671@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:05 -0700
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
Subject: [38/66] Phonet: Correct header retrieval after pskb_may_pull
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -224,12 +224,13 @@ static void pipe_grant_credits(struct so
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


