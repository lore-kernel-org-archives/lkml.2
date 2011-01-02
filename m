Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1ABHlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:41:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:36649 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1ABHYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ulrich Weber <uweber@astaro.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 192/260] xfrm4: strip ECN bits from tos field
Date: Sun,  2 Jan 2011 02:18:08 -0500
Message-Id: <1293952756-15010-193-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:40.0932 (UTC) FILETIME=[FAEE5C40:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Weber <uweber@astaro.com>

commit 94e2238969e89f5112297ad2a00103089dde7e8f upstream.

otherwise ECT(1) bit will get interpreted as RTO_ONLINK
and routing will fail with XfrmOutBundleGenError.

Signed-off-by: Ulrich Weber <uweber@astaro.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/xfrm4_policy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index e4a1483..0670587 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -82,7 +82,7 @@ __xfrm4_find_bundle(struct flowi *fl, struct xfrm_policy *policy)
 
 static int xfrm4_get_tos(struct flowi *fl)
 {
-	return fl->fl4_tos;
+	return IPTOS_RT_MASK & fl->fl4_tos; /* Strip ECN bits */
 }
 
 static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,
-- 
1.7.3.3

