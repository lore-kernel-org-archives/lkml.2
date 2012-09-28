Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946259Ab2I1Vbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:31:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51449 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032644Ab2I1U2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 122/218] NFS: return error from decode_getfh in decode open
Date: Fri, 28 Sep 2012 13:15:39 -0700
Message-Id: <20120928201515.477230562@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6081,7 +6081,8 @@ static int nfs4_xdr_dec_open(struct rpc_
 	status = decode_open(xdr, res);
 	if (status)
 		goto out;
-	if (decode_getfh(xdr, &res->fh) != 0)
+	status = decode_getfh(xdr, &res->fh);
+	if (status)
 		goto out;
 	if (decode_getfattr(xdr, res->f_attr, res->server) != 0)
 		goto out;


