Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab2CMA45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:56:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47788 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab2CMAWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 082/196] can: Add missing socket check in can/bcm release.
Date: Mon, 12 Mar 2012 20:19:55 -0400
Message-Id: <1331598109-31424-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c6914a6f261aca0c9f715f883a353ae7ff51fe83 upstream.

We can get here with a NULL socket argument passed from userspace,
so we need to handle it accordingly.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/can/bcm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index dd23fb1..a6445fd 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1426,9 +1426,14 @@ static int bcm_init(struct sock *sk)
 static int bcm_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
-	struct bcm_sock *bo = bcm_sk(sk);
+	struct bcm_sock *bo;
 	struct bcm_op *op, *next;
 
+	if (sk == NULL)
+		return 0;
+
+	bo = bcm_sk(sk);
+
 	/* remove bcm_ops, timer, rx_unregister(), etc. */
 
 	unregister_netdevice_notifier(&bo->notifier);
-- 
1.7.9.3

