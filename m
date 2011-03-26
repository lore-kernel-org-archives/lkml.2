Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab1CZAHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:07:41 -0400
Received: from kroah.org ([198.145.64.141]:35966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449Ab1CZAGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:59 2011
Message-Id: <20110326000459.281889618@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:04:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [33/35] SUNRPC: Never reuse the socket port after an xs_close()
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 246408dcd5dfeef2df437ccb0ef4d6ee87805f58 upstream.

If we call xs_close(), we're in one of two situations:
 - Autoclose, which means we don't expect to resend a request
 - bind+connect failed, which probably means the port is in use

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -729,6 +729,8 @@ static void xs_reset_transport(struct so
 	if (sk == NULL)
 		return;
 
+	transport->srcport = 0;
+
 	write_lock_bh(&sk->sk_callback_lock);
 	transport->inet = NULL;
 	transport->sock = NULL;


