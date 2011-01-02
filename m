Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1ABHZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:36755 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1ABHY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 201/260] rose: Fix signedness issues wrt. digi count.
Date: Sun,  2 Jan 2011 02:18:17 -0500
Message-Id: <1293952756-15010-202-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:50.0588 (UTC) FILETIME=[00AFBFC0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 9828e6e6e3f19efcb476c567b9999891d051f52f upstream.

Just use explicit casts, since we really can't change the
types of structures exported to userspace which have been
around for 15 years or so.

Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/rose/af_rose.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 4fb711a..d325c9d 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -679,7 +679,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	if ((dev = rose_dev_get(&addr->srose_addr)) == NULL) {
@@ -739,7 +739,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	/* Source + Destination digis should not exceed ROSE_MAX_DIGIS */
-- 
1.7.3.3

