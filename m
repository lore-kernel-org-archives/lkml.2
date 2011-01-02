Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1ABHwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:52:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:35663 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1ABHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 127/260] net/llc: make opt unsigned in llc_ui_setsockopt()
Date: Sun,  2 Jan 2011 02:17:03 -0500
Message-Id: <1293952756-15010-128-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:28.0727 (UTC) FILETIME=[CFE4C070:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 339db11b219f36cf7da61b390992d95bb6b7ba2e upstream.

The members of struct llc_sock are unsigned so if we pass a negative
value for "opt" it can cause a sign bug.  Also it can cause an integer
overflow when we multiply "opt * HZ".

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/llc/af_llc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 2db6a9f..ad4296c 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1024,7 +1024,8 @@ static int llc_ui_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
-	int rc = -EINVAL, opt;
+	unsigned int opt;
+	int rc = -EINVAL;
 
 	lock_sock(sk);
 	if (unlikely(level != SOL_LLC || optlen != sizeof(int)))
-- 
1.7.3.3

