Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2CMAzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:55:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:47815 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722Ab2CMAWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 083/196] can: add missing socket check in can/raw release
Date: Mon, 12 Mar 2012 20:19:56 -0400
Message-Id: <1331598109-31424-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 10022a6c66e199d8f61d9044543f38785713cbbd upstream.

v2: added space after 'if' according code style.

We can get here with a NULL socket argument passed from userspace,
so we need to handle it accordingly.

Thanks to Dave Jones pointing at this issue in net/can/bcm.c

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/can/raw.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index da99cf1..9dd45ea 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -281,7 +281,12 @@ static int raw_init(struct sock *sk)
 static int raw_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
-	struct raw_sock *ro = raw_sk(sk);
+	struct raw_sock *ro;
+
+	if (!sk)
+		return 0;
+
+	ro = raw_sk(sk);
 
 	unregister_netdevice_notifier(&ro->notifier);
 
-- 
1.7.9.3

