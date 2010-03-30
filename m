Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0C3XVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:25 -0400
Received: from kroah.org ([198.145.64.141]:46122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab0C3XUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:12 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:01 2010
Message-Id: <20100330224800.780780584@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [062/156] Revert "sunrpc: fix peername failed on closed listener"
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit f5822754ea006563e1bf0a1f43faaad49c0d8bb2 upstream.

This reverts commit b292cf9ce70d221c3f04ff62db5ab13d9a249ca8.  The
commit that it attempted to patch up,
b0401d725334a94d57335790b8ac2404144748ee, was fundamentally wrong, and
will also be reverted.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svc_xprt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -699,8 +699,7 @@ int svc_recv(struct svc_rqst *rqstp, lon
 	spin_unlock_bh(&pool->sp_lock);
 
 	len = 0;
-	if (test_bit(XPT_LISTENER, &xprt->xpt_flags) &&
-	    !test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
+	if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
 		struct svc_xprt *newxpt;
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {


