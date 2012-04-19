Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab2DSVN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:13:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33843 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab2DSVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:20 -0400
Message-Id: <20120419210304.675970146@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Mason <chris.mason@oracle.com>
Subject: [ 18/75] Revert "Btrfs: increase the global block reserve estimates"
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <chris.mason@oracle.com>

commit 8e62c2de6e23e5c1fee04f59de51b54cc2868ca5 upstream.

This reverts commit 5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf.

We've had a number of complaints of early enospc that bisect down
to this patch.  We'll hae to fix the reservations differently.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4110,7 +4110,7 @@ static u64 calc_global_metadata_size(str
 	num_bytes += div64_u64(data_used + meta_used, 50);
 
 	if (num_bytes * 3 > meta_used)
-		num_bytes = div64_u64(meta_used, 3) * 2;
+		num_bytes = div64_u64(meta_used, 3);
 
 	return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
 }


