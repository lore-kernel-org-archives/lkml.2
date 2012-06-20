Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab2FTSWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab2FTSV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:57 -0400
Message-Id: <20120620173022.107918859@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 13/61] NFSv4.1: Fix a request leak on the back channel
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b3b02ae5865c2dcd506322e0fc6def59a042e72f upstream.

If the call to svc_process_common() fails, then the request
needs to be freed before we can exit bc_svc_process.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1379,7 +1379,8 @@ bc_svc_process(struct svc_serv *serv, st
 						sizeof(req->rq_snd_buf));
 		return bc_send(req);
 	} else {
-		/* Nothing to do to drop request */
+		/* drop request */
+		xprt_free_bc_request(req);
 		return 0;
 	}
 }


