Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030691Ab2CITrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39298 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030643Ab2CITrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:48 -0500
Message-Id: <20120309190205.719929501@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Phil Sutter <phil.sutter@viprinet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 42/95] crypto: mv_cesa - fix final callback not ignoring input data
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil.sutter@viprinet.com>

commit f8f54e190ddb4ed697036b60f5e2ae6dd45b801c upstream.

Broken by commit 6ef84509f3d439ed2d43ea40080643efec37f54f for users
passing a request with non-zero 'nbytes' field, like e.g. testmgr.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/mv_cesa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -714,6 +714,7 @@ static int mv_hash_final(struct ahash_re
 {
 	struct mv_req_hash_ctx *ctx = ahash_request_ctx(req);
 
+	ahash_request_set_crypt(req, NULL, req->result, 0);
 	mv_update_hash_req_ctx(ctx, 1, 0);
 	return mv_handle_req(&req->base);
 }


