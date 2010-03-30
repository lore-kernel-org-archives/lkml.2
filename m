Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0CaAlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:41:50 -0400
Received: from kroah.org ([198.145.64.141]:48422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab0C3XI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:56 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:46 2010
Message-Id: <20100330224945.987478556@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [11/45] ax25: Fix possible oops in ax25_make_new
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

commit 8c185ab6185bf5e67766edb000ce428269364c86 upstream.

In ax25_make_new, if kmemdup of digipeat returns an error, there would
be an oops in sk_free while calling sk_destruct, because sk_protinfo
is NULL at the moment; move sk->sk_destruct initialization after this.

BTW of reported-by: Bernard Pidoux F6BVP <f6bvp@free.fr>

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -894,7 +894,6 @@ struct sock *ax25_make_new(struct sock *
 
 	sock_init_data(NULL, sk);
 
-	sk->sk_destruct = ax25_free_sock;
 	sk->sk_type     = osk->sk_type;
 	sk->sk_priority = osk->sk_priority;
 	sk->sk_protocol = osk->sk_protocol;
@@ -932,6 +931,7 @@ struct sock *ax25_make_new(struct sock *
 	}
 
 	sk->sk_protinfo = ax25;
+	sk->sk_destruct = ax25_free_sock;
 	ax25->sk    = sk;
 
 	return sk;


