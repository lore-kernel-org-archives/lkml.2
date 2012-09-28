Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031122Ab2I1UsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:48:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38475 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422938Ab2I1Ur5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:57 -0400
X-Sasl-enc: tj0/uzYnPMWGPrQ1yFgENVlDD1XI8+EL+DtDMUNsyEHr 1348865276
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 072/127] NFS: return error from decode_getfh in decode open
Date: Fri, 28 Sep 2012 13:34:05 -0700
Message-Id: <20120928203054.300938581@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit 01913b49cf1dc6409a07dd2a4cc6af2e77f3c410 upstream.

If decode_getfh failed, nfs4_xdr_dec_open would return 0 since the last
decode_* call must have succeeded.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4xdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -5745,7 +5745,8 @@ static int nfs4_xdr_dec_open(struct rpc_
 	status = decode_open(xdr, res);
 	if (status)
 		goto out;
-	if (decode_getfh(xdr, &res->fh) != 0)
+	status = decode_getfh(xdr, &res->fh);
+	if (status)
 		goto out;
 	if (decode_getfattr(xdr, res->f_attr, res->server,
 				!RPC_IS_ASYNC(rqstp->rq_task)) != 0)


