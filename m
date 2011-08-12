Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1HNQI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab1HNQIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.314378286@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>, "David S. Miller" <davem@davemloft.net>
Subject: [48/90] drivers/net/niu.c: adjust array index
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Julia Lawall <julia@diku.dk>

[ Upstream commit 956837f7c954443f426a82ba6f17b33488cf9a0c ]

Convert array index from the loop bound to the loop index.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,ar;
@@

for(e1 = 0; e1 < e2; e1++) { <...
  ar[
- e2
+ e1
  ]
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/niu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -9196,7 +9196,7 @@ static int __devinit niu_ldg_init(struct
 
 	first_chan = 0;
 	for (i = 0; i < port; i++)
-		first_chan += parent->rxchan_per_port[port];
+		first_chan += parent->rxchan_per_port[i];
 	num_chan = parent->rxchan_per_port[port];
 
 	for (i = first_chan; i < (first_chan + num_chan); i++) {
@@ -9212,7 +9212,7 @@ static int __devinit niu_ldg_init(struct
 
 	first_chan = 0;
 	for (i = 0; i < port; i++)
-		first_chan += parent->txchan_per_port[port];
+		first_chan += parent->txchan_per_port[i];
 	num_chan = parent->txchan_per_port[port];
 	for (i = first_chan; i < (first_chan + num_chan); i++) {
 		err = niu_ldg_assign_ldn(np, parent,


