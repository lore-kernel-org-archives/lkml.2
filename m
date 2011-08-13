Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1HMOML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:12:11 -0400
Received: from www17.your-server.de ([213.133.104.17]:56401 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1HMOMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:12:00 -0400
Subject: [PATCH] sctp: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:43:45 +0200
Message-ID: <1313228625.16820.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/net/sctp/protocol.c b/net/sctp/protocol.c
--- a/net/sctp/protocol.c 2011-07-26 00:46:12.663489013 +0200
+++ b/net/sctp/protocol.c 2011-08-01 20:02:43.478907122 +0200
@@ -1337,7 +1337,7 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Allocate and initialize the endpoint hash table.  */
 	sctp_ep_hashsize = 64;
-	sctp_ep_hashtable = (struct sctp_hashbucket *)
+	sctp_ep_hashtable =
 		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
 	if (!sctp_ep_hashtable) {
 		pr_err("Failed endpoint_hash alloc\n");


