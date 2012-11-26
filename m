Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab2KZR3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:29:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab2KZRNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 222/270] SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
Date: Mon, 26 Nov 2012 14:58:32 -0200
Message-Id: <1353949160-26803-223-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d0bea455dd48da1ecbd04fedf00eb89437455fdc upstream.

This is needed to ensure that we call xprt_connect() upon the next
call to call_connect().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/xprtsock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 00ff343..683f990b 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1528,6 +1528,7 @@ static void xs_tcp_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
 		xprt->connect_cookie++;
+		clear_bit(XPRT_CONNECTED, &xprt->state);
 		xs_tcp_force_close(xprt);
 	case TCP_CLOSING:
 		/*
-- 
1.7.9.5

