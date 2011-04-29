Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab1D2TJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:09:39 -0400
Received: from kroah.org ([198.145.64.141]:50182 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664Ab1D2S6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.277333799@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [07/55] nfsd4: fix struct file leak on delegation
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

commit 4ee63624fd927376b97ead3a8d00728d437bc8e8 upstream.

Introduced by acfdf5c383b38f7f4dddae41b97c97f1ae058f49.

Reported-by: Gerhard Heift <ml-nfs-linux-20110412-ef47@gheift.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -258,6 +258,7 @@ static void nfs4_put_deleg_lease(struct
 	if (atomic_dec_and_test(&fp->fi_delegees)) {
 		vfs_setlease(fp->fi_deleg_file, F_UNLCK, &fp->fi_lease);
 		fp->fi_lease = NULL;
+		fput(fp->fi_deleg_file);
 		fp->fi_deleg_file = NULL;
 	}
 }


