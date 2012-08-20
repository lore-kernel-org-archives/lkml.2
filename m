Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2HTD6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:58:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab2HTD62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 17/32] ext4: avoid kmemcheck complaint from reading uninitialized memory
Date: Sun, 19 Aug 2012 20:57:13 -0700
Message-Id: <20120820035650.242768924@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7e731bc9a12339f344cddf82166b82633d99dd86 upstream.

Commit 03179fe923 introduced a kmemcheck complaint in
ext4_da_get_block_prep() because we save and restore
ei->i_da_metadata_calc_last_lblock even though it is left
uninitialized in the case where i_da_metadata_calc_len is zero.

This doesn't hurt anything, but silencing the kmemcheck complaint
makes it easier for people to find real bugs.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=45631
(which is marked as a regression).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -932,6 +932,7 @@ static struct inode *ext4_alloc_inode(st
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_da_metadata_calc_len = 0;
+	ei->i_da_metadata_calc_last_lblock = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;


