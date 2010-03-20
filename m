Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0CTL0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:26:17 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43094 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0CTL0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=hMVJu3QcIoukHTuEQFIEUwiuGlTzuExk/5ZWNFnG0yfUuco7TKF4D0zAULcbBt932N
         8zqf/f0AyqNhCMslsMGIGrwNQCcCDmjAOXF39aDlMnG+O6bfkm7qrAFJrdLU1MJZdnXh
         f0pmB0m8V9TfyuUaVgcjMYz4XLiD/j7rPu2GA=
Date: Sat, 20 Mar 2010 14:26:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Carpenter <error27@gmail.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 1/3] btrfs cleanup: remove dead code
Message-ID: <20100320112605.GY5331@bicker>
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

rb_node is never an ERR_PTR() here.  This code confuses smatch.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This doesn't change anything.  It's just a cleanup.  Could you load
it up for linux-next?

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 28d87ba..94668b1 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -335,10 +335,6 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 		em = NULL;
 		goto out;
 	}
-	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
-		goto out;
-	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
 	if (end > em->start && start < extent_map_end(em))
 		goto found;
