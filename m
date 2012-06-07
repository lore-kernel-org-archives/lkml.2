Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2FGEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:16:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2FGEQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:16:50 -0400
Message-Id: <20120607040339.597396005@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:58 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 22/82] NFS: kmalloc() doesnt return an ERR_PTR()
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5abc03cd919535c61b813f2319cb38326a41e810 upstream.

Obviously we should check for NULL here instead of IS_ERR().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/idmap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -640,20 +640,16 @@ static int nfs_idmap_legacy_upcall(struc
 	struct idmap_msg *im;
 	struct idmap *idmap = (struct idmap *)aux;
 	struct key *key = cons->key;
-	int ret;
+	int ret = -ENOMEM;
 
 	/* msg and im are freed in idmap_pipe_destroy_msg */
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
-	if (IS_ERR(msg)) {
-		ret = PTR_ERR(msg);
+	if (!msg)
 		goto out0;
-	}
 
 	im = kmalloc(sizeof(*im), GFP_KERNEL);
-	if (IS_ERR(im)) {
-		ret = PTR_ERR(im);
+	if (!im)
 		goto out1;
-	}
 
 	ret = nfs_idmap_prepare_message(key->description, im, msg);
 	if (ret < 0)


