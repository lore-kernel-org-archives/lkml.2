Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2HMWcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:32:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48802 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab2HMWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:15:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 04/65] SUNRPC: return negative value in case rpcbind client creation error
Date: Mon, 13 Aug 2012 15:13:48 -0700
Message-Id: <20120813221415.356015828@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit caea33da898e4e14f0ba58173e3b7689981d2c0b upstream.

Without this patch kernel will panic on LockD start, because lockd_up() checks
lockd_up_net() result for negative value.
>From my pow it's better to return negative value from rpcbind routines instead
of replacing all such checks like in lockd_up().

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/rpcb_clnt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -251,7 +251,7 @@ static int rpcb_create_local_unix(struct
 	if (IS_ERR(clnt)) {
 		dprintk("RPC:       failed to create AF_LOCAL rpcbind "
 				"client (errno %ld).\n", PTR_ERR(clnt));
-		result = -PTR_ERR(clnt);
+		result = PTR_ERR(clnt);
 		goto out;
 	}
 
@@ -298,7 +298,7 @@ static int rpcb_create_local_net(struct
 	if (IS_ERR(clnt)) {
 		dprintk("RPC:       failed to create local rpcbind "
 				"client (errno %ld).\n", PTR_ERR(clnt));
-		result = -PTR_ERR(clnt);
+		result = PTR_ERR(clnt);
 		goto out;
 	}
 


