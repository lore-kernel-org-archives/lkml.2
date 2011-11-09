Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935836Ab1KJE0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:26:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab1KJDjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:50 2011
Message-Id: <20111109213150.851158920@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jim Rees <rees@umich.edu>,
        Benny Halevy <bhalevy@tonian.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [087/264] pnfsblock: fix size of upcall message
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Rees <rees@umich.edu>

commit fdc17abbc4b6094b34ee8ff5d91eaba8637594a2 upstream.

Make the status field explicitly 32 bits.  "...it's unlikely that the kernel
and userspace would differ on the size of an int here, but it might be a
good idea to go ahead and make that explicitly 32 bits in case we end up
dealing with more exotic arches at some point in the future."

Suggested-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Jim Rees <rees@umich.edu>
Signed-off-by: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/blocklayout.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/blocklayout/blocklayout.h
+++ b/fs/nfs/blocklayout/blocklayout.h
@@ -150,7 +150,7 @@ BLK_LSEG2EXT(struct pnfs_layout_segment
 }
 
 struct bl_dev_msg {
-	int status;
+	int32_t status;
 	uint32_t major, minor;
 };
 


