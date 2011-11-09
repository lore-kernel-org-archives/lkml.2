Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936059Ab1KJDoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:44:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965441Ab1KJDoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:59 2011
Message-Id: <20111109213159.525555162@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yongqiang Yang <xiaoqiangnk@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [172/264] ext4: let ext4_page_mkwrite stop started handle in failure
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

commit fcbb5515825f1bb20b7a6f75ec48bee61416f879 upstream.

The started journal handle should be stopped in failure case.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4416,6 +4416,7 @@ retry_alloc:
 			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
 			unlock_page(page);
 			ret = VM_FAULT_SIGBUS;
+			ext4_journal_stop(handle);
 			goto out;
 		}
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);


