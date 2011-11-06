Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1KFN2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:28:37 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41024 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab1KFN05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:26:57 -0500
From: Julia Lawall <julia@diku.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] net/rfkill/core.c: use kstrtoul, etc
Date: Sun,  6 Nov 2011 14:26:49 +0100
Message-Id: <1320586010-21931-5-git-send-email-julia@diku.dk>
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
 net/rfkill/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/net/rfkill/core.c b/net/rfkill/core.c
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -644,7 +644,7 @@ static ssize_t rfkill_soft_store(struct
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 0, &state);
+	err = kstrtoul(buf, 0, &state);
 	if (err)
 		return err;
 
@@ -688,7 +688,7 @@ static ssize_t rfkill_state_store(struct
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 0, &state);
+	err = kstrtoul(buf, 0, &state);
 	if (err)
 		return err;
 

