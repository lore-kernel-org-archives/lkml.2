Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2CMA4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:56:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:47807 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab2CMAWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kees Cook <kees.cook@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 079/196] net: ax25: fix information leak to userland harder
Date: Mon, 12 Mar 2012 20:19:52 -0400
Message-Id: <1331598109-31424-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5b919f833d9d60588d026ad82d17f17e8872c7a9 upstream.

Commit fe10ae53384e48c51996941b7720ee16995cbcb7 adds a memset() to clear
the structure being sent back to userspace, but accidentally used the
wrong size.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index eb100ce..12c350c 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1392,7 +1392,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	ax25_cb *ax25;
 	int err = 0;
 
-	memset(fsa, 0, sizeof(fsa));
+	memset(fsa, 0, sizeof(*fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
-- 
1.7.9.3

