Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1KFN1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:27:05 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41038 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab1KFN1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:27:01 -0500
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] net/dns_resolver/dns_key.c: use kstrtoul, etc
Date: Sun,  6 Nov 2011 14:26:50 +0100
Message-Id: <1320586010-21931-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1320586010-21931-1-git-send-email-julia@diku.dk>
References: <1320586010-21931-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrtoul, etc instead of the now deprecated strict_strtoul, etc.

A semantic patch rule for the kstrtoul case is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,b;
{int,long} *c;
@@

-strict_strtoul
+kstrtoul
 (a,b,c)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/dns_resolver/dns_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -118,7 +118,7 @@ dns_resolver_instantiate(struct key *key
 				if (opt_vlen <= 0)
 					goto bad_option_value;
 
-				ret = strict_strtoul(eq, 10, &derrno);
+				ret = kstrtoul(eq, 10, &derrno);
 				if (ret < 0)
 					goto bad_option_value;
 

