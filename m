Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1ALFkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:40:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35238 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab1ALFkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:40:40 -0500
Date: Tue, 11 Jan 2011 21:40:22 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Brad Spengler <spender@grsecurity.net>,
        Vasiliy Kulikov <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org Joerg Reuter" <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] net: ax25: fix information leak to userland harder
Message-ID: <20110112054022.GR4979@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fe10ae53384e48c51996941b7720ee16995cbcb7 adds a memset() to clear
the structure being sent back to userspace, but accidentally used the
wrong size.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: stable@kernel.org
---
 net/ax25/af_ax25.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index bb86d29..6da5dae 100644
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
1.7.2.3


-- 
Kees Cook
Ubuntu Security Team
