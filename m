Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0DVU12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:27:28 -0400
Received: from kroah.org ([198.145.64.141]:59564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773Ab0DVT77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:59 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:08 2010
Message-Id: <20100422195407.957633020@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wu Fengguang <fengguang.wu@intel.com>, Yan Zheng <yanzheng@21cn.com>
Subject: [032/139] readahead: fix NULL filp dereference
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 70655c06bd3f25111312d63985888112aed15ac5 upstream.

btrfs relocate_file_extent_cluster() calls us with NULL filp:

  [ 4005.426805] BUG: unable to handle kernel NULL pointer dereference at 00000021
  [ 4005.426818] IP: [<c109a130>] page_cache_sync_readahead+0x18/0x3e

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Yan Zheng <yanzheng@21cn.com>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -502,7 +502,7 @@ void page_cache_sync_readahead(struct ad
 		return;
 
 	/* be dumb */
-	if (filp->f_mode & FMODE_RANDOM) {
+	if (filp && (filp->f_mode & FMODE_RANDOM)) {
 		force_page_cache_readahead(mapping, filp, offset, req_size);
 		return;
 	}


