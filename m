Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab0GUHlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:41:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0GUHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:41:47 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-nfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] SUNRPC auth: add context argument to shrinker callback
Date: Wed, 21 Jul 2010 09:41:35 +0200
Message-Id: <1279698095-17287-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found this regression in the current mainline tree.

Please review,
Marc

---------8<--------8<--------8<--------8<--------8<--------8<--------8<-------

This patch fixes a regression introduced with commit
7f8275d0d660c146de6ee3017e1e2e594c49e820, the signature of the shrinker
callback has been changes, but this file has not been modified.

This results in the following compiler warning:

net/sunrpc/auth.c:586: warning: initialization from incompatible pointer
type

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/sunrpc/auth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 73affb8..8dc47f1 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -267,7 +267,7 @@ rpcauth_prune_expired(struct list_head *free, int nr_to_scan)
  * Run memory cache shrinker.
  */
 static int
-rpcauth_cache_shrinker(int nr_to_scan, gfp_t gfp_mask)
+rpcauth_cache_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 {
 	LIST_HEAD(free);
 	int res;
-- 
1.7.1

