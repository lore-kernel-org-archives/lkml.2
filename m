Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab0HEUTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:19:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55353 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934045Ab0HEUTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:19:02 -0400
Date: Thu, 5 Aug 2010 22:19:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/42] net/atm: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052218400.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Outdent the code following an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/atm/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/common.c b/net/atm/common.c
index 940404a..1b9c52a 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -792,7 +792,7 @@ int vcc_getsockopt(struct socket *sock, int level, int optname,
 	default:
 		if (level == SOL_SOCKET)
 			return -EINVAL;
-			break;
+		break;
 	}
 	if (!vcc->dev || !vcc->dev->ops->getsockopt)
 		return -EINVAL;
