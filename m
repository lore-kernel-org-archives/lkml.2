Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1KJETn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:19:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301Ab1KJDlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:41:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:51 2011
Message-Id: <20111109213151.328205152@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <peng_tao@emc.com>,
        Jim Rees <rees@umich.edu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [092/264] pnfsblock: fix NULL pointer dereference
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit e6d05a757c314ad88d0649d3835a8a1daa964236 upstream.

bl_add_page_to_bio returns error pointer. bio should be reset to
NULL in failure cases as the out path always calls bl_submit_bio.

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Jim Rees <rees@umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/blocklayout.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -292,6 +292,7 @@ bl_read_pagelist(struct nfs_read_data *r
 						 bl_end_io_read, par);
 			if (IS_ERR(bio)) {
 				rdata->pnfs_error = PTR_ERR(bio);
+				bio = NULL;
 				goto out;
 			}
 		}
@@ -581,6 +582,7 @@ fill_invalid_ext:
 						 bl_end_io_write_zero, par);
 			if (IS_ERR(bio)) {
 				wdata->pnfs_error = PTR_ERR(bio);
+				bio = NULL;
 				goto out;
 			}
 			/* FIXME: This should be done in bi_end_io */
@@ -629,6 +631,7 @@ next_page:
 					 bl_end_io_write, par);
 		if (IS_ERR(bio)) {
 			wdata->pnfs_error = PTR_ERR(bio);
+			bio = NULL;
 			goto out;
 		}
 		isect += PAGE_CACHE_SECTORS;


