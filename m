Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab1FPHKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:23 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34723 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555Ab1FPHKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:18 -0400
X-Sasl-enc: Cq9fUf//uYJd7l4tbx8AYjyawvo4N9NidRey4WaHP0U0 1308208218
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:05 2011
Message-Id: <20110616002905.107366405@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yang Ruirui <ruirui.r.yang@tieto.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [13/85] ext4: release page cache in ext4_mb_load_buddy error path
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1138,6 +1138,8 @@ repeat_load_buddy:
 	return 0;
 
 err:
+	if (page)
+		page_cache_release(page);
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)


