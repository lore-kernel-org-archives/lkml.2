Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0CTLhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:37:43 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46328 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0CTLhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=WjfwDS04J7JCC+Bs2Abe8HGbAHcOHpFMAMTTVsIIDbr0V8288VXkas9jZ4ECHkCGXc
         swmLmNvlhtlOUQk1iV1qeCIpk5T9jOO4cSMk6KczaCAmWJzUBt6B80XVqikpczkXB5qJ
         fb4/+3L5lcSa77qBKBrTuGMgb4z10we7CG+iQ=
Date: Sat, 20 Mar 2010 14:37:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Dan Carpenter <error27@gmail.com>, Christoph Hellwig <hch@lst.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 2/3] btrfs cleanup: remove more dead code
Message-ID: <20100320113730.GZ5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rb_node cannot be an ERR_PTR() here so I removed the misleading check.
Also I removed some more dead code at the bottom.

It looks like the code from lookup_extent_mapping() may have been 
copy and pasted into search_extent_mapping()?

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This doesn't change anything.  Could you put it into linux-next?

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 94668b1..010f299 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -380,16 +380,7 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 		em = NULL;
 		goto out;
 	}
-	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
-		goto out;
-	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
-	goto found;
-
-	em = NULL;
-	goto out;
-
 found:
 	atomic_inc(&em->refs);
 out:
