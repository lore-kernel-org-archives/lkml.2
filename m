Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0HYHMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:12:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48514 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0HYHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Mxuy55BilTKLsAwpzNFCyYgE+f3BlpUtQB/+lA8h51ns+mHtBVKHH7DAT7KV4TrVvk
         Vdsr+G2CUXUeCUvnIoHEB1XcBUWksLye66Nanff/QhGTjQqkj40rHtQXYVbZaAA0wj5H
         xBswApxIPHpkFEwRvoDPOE0lYFX+qOzoOBBqY=
Date: Wed, 25 Aug 2010 09:11:35 +0200
From: Dan Carpenter <error27@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ceph: ceph_get_inode() returns an ERR_PTR
Message-ID: <20100825071135.GO29330@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Sage Weil <sage@newdream.net>,
	Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph_get_inode() returns an ERR_PTR and it doesn't return a NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5d893d3..1e623ec 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1229,11 +1229,11 @@ retry_lookup:
 			in = dn->d_inode;
 		} else {
 			in = ceph_get_inode(parent->d_sb, vino);
-			if (in == NULL) {
+			if (IS_ERR(in)) {
 				dout("new_inode badness\n");
 				d_delete(dn);
 				dput(dn);
-				err = -ENOMEM;
+				err = PTR_ERR(in);
 				goto out;
 			}
 			dn = splice_dentry(dn, in, NULL);
