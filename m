Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab1DNSSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:18:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:41638 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab1DNR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 138/209] tcp: Increase TCP_MAXSEG socket option minimum.
Date: Thu, 14 Apr 2011 13:54:56 -0400
Message-Id: <1302803767-9715-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 7a1abd08d52fdeddb3e9a5a33f2f15cc6a5674d2 upstream

As noted by Steve Chen, since commit
f5fff5dc8a7a3f395b0525c02ba92c95d42b7390 ("tcp: advertise MSS
requested by user") we can end up with a situation where
tcp_select_initial_window() does a divide by a zero (or
even negative) mss value.

The problem is that sometimes we effectively subtract
TCPOLEN_TSTAMP_ALIGNED and/or TCPOLEN_MD5SIG_ALIGNED from the mss.

Fix this by increasing the minimum from 8 to 64.

Reported-by: Steve Chen <schen@mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68cd299..5ad716b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2234,7 +2234,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		/* Values greater than interface MTU won't take effect. However
 		 * at the point when this call is done we typically don't yet
 		 * know which interface is going to be used */
-		if (val < 8 || val > MAX_TCP_WINDOW) {
+		if (val < 64 || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}
-- 
1.7.4.4

