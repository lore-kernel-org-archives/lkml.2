Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161502Ab1FAIKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:43366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161183Ab1FAIKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:19 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:08 2011
Message-Id: <20110601080307.908230547@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:42 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yang Ruirui <ruirui.r.yang@tieto.com>, "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [046/146] ext4: release page cache in ext4_mb_load_buddy error path
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yang Ruirui <ruirui.r.yang@tieto.com>

commit 26626f1172fb4f3f323239a6a5cf4e082643fa46 upstream.

Add missing page_cache_release in the error path of ext4_mb_load_buddy

Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1268,6 +1268,8 @@ repeat_load_buddy:
 	return 0;
 
 err:
+	if (page)
+		page_cache_release(page);
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)


