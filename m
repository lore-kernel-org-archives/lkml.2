Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1DSU1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:27:51 -0400
Received: from kroah.org ([198.145.64.141]:47668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab1DSURJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.813029835@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [25/70] sctp: Pass __GFP_NOWARN to hash table allocation attempts.
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit a84b50ceb7d640437d0dc28a2bef0d0de054de89 ]

Like DCCP and other similar pieces of code, there are mechanisms
here to try allocating smaller hash tables if the allocation
fails.  So pass in __GFP_NOWARN like the others do instead of
emitting a scary message.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sctp/protocol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1204,7 +1204,7 @@ SCTP_STATIC __init int sctp_init(void)
 		if ((sctp_assoc_hashsize > (64 * 1024)) && order > 0)
 			continue;
 		sctp_assoc_hashtable = (struct sctp_hashbucket *)
-					__get_free_pages(GFP_ATOMIC, order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, order);
 	} while (!sctp_assoc_hashtable && --order > 0);
 	if (!sctp_assoc_hashtable) {
 		pr_err("Failed association hash alloc\n");
@@ -1237,7 +1237,7 @@ SCTP_STATIC __init int sctp_init(void)
 		if ((sctp_port_hashsize > (64 * 1024)) && order > 0)
 			continue;
 		sctp_port_hashtable = (struct sctp_bind_hashbucket *)
-					__get_free_pages(GFP_ATOMIC, order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, order);
 	} while (!sctp_port_hashtable && --order > 0);
 	if (!sctp_port_hashtable) {
 		pr_err("Failed bind hash alloc\n");


