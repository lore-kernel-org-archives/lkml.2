Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163218Ab1FAI3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:29:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:45281 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163191Ab1FAI2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:55 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:25 2011
Message-Id: <20110601081225.182613639@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:06 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vitaliy Gusev <gusev.vitaliy@nexenta.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [156/165] nfs41: Correct offset for LAYOUTCOMMIT
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 845
Lines: 28

From: Vitaliy Gusev <gusev.vitaliy@gmail.com>

commit 4b8ee2b82e8b0b6e17ee33feb74fcdb5c6d8dbdd upstream.

A client sends offset to MDS as it was seen by DS. As result,
file size after copy is only half of original file size in case
of 2 DS.

Signed-off-by: Vitaliy Gusev <gusev.vitaliy@nexenta.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1009,7 +1009,7 @@ void
 pnfs_set_layoutcommit(struct nfs_write_data *wdata)
 {
 	struct nfs_inode *nfsi = NFS_I(wdata->inode);
-	loff_t end_pos = wdata->args.offset + wdata->res.count;
+	loff_t end_pos = wdata->mds_offset + wdata->res.count;
 	bool mark_as_dirty = false;
 
 	spin_lock(&nfsi->vfs_inode.i_lock);


