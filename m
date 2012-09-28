Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478Ab2I1TB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:01:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab2I1TBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 151/262] NFS: return error from decode_getfh in decode open
Date: Fri, 28 Sep 2012 11:51:20 -0700
Message-Id: <20120928183015.869366294@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6262,7 +6262,8 @@ static int nfs4_xdr_dec_open(struct rpc_
 	status = decode_open(xdr, res);
 	if (status)
 		goto out;
-	if (decode_getfh(xdr, &res->fh) != 0)
+	status = decode_getfh(xdr, &res->fh);
+	if (status)
 		goto out;
 	decode_getfattr(xdr, res->f_attr, res->server);
 out:


