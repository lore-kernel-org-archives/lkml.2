Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1G0AiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:38:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:34282 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab1G0AfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471186"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: davej@redhat.com, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [29/98] can: Add missing socket check in can/bcm release.
Message-Id: <20110727003521.7A4EE2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dave Jones <davej@redhat.com>

commit c6914a6f261aca0c9f715f883a353ae7ff51fe83 upstream.

We can get here with a NULL socket argument passed from userspace,
so we need to handle it accordingly.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/can/bcm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/can/bcm.c
===================================================================
--- linux-2.6.35.y.orig/net/can/bcm.c
+++ linux-2.6.35.y/net/can/bcm.c
@@ -1424,9 +1424,14 @@ static int bcm_init(struct sock *sk)
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
