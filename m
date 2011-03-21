Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab1CUXxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:53:40 -0400
Received: from kroah.org ([198.145.64.141]:49241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1CUXPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230709.994308833@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [08/87] sunrpc: Propagate errors from xs_bind() through xs_create_sock()
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 4cea288aaf0e11647880cc487350b1dc45d9febc upstream.

xs_create_sock() is supposed to return a pointer or an ERR_PTR-encoded
error, but it currently returns 0 if xs_bind() fails.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1631,7 +1631,8 @@ static struct socket *xs_create_sock(str
 	}
 	xs_reclassify_socket(family, sock);
 
-	if (xs_bind(transport, sock)) {
+	err = xs_bind(transport, sock);
+	if (err) {
 		sock_release(sock);
 		goto out;
 	}


