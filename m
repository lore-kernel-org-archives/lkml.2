Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577Ab2J2VyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:54:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:48514 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761534Ab2J2VlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chris Perl <chris.perl@gmail.com>
Subject: [ 12/54] SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
Date: Mon, 29 Oct 2012 14:40:13 -0700
Message-Id: <20121029213804.138519967@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d0bea455dd48da1ecbd04fedf00eb89437455fdc upstream.

This is needed to ensure that we call xprt_connect() upon the next
call to call_connect().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtsock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1525,6 +1525,7 @@ static void xs_tcp_state_change(struct s
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
 		xprt->connect_cookie++;
+		clear_bit(XPRT_CONNECTED, &xprt->state);
 		xs_tcp_force_close(xprt);
 	case TCP_CLOSING:
 		/*


