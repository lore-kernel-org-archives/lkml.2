Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab1EFA6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:58:36 -0400
Received: from kroah.org ([198.145.64.141]:36708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab1EFAYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.054241288@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [039/143] can: Add missing socket check in can/bcm release.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Jones <davej@redhat.com>

commit c6914a6f261aca0c9f715f883a353ae7ff51fe83 upstream.

We can get here with a NULL socket argument passed from userspace,
so we need to handle it accordingly.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/bcm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1425,9 +1425,14 @@ static int bcm_init(struct sock *sk)
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


