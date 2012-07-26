Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2GZVVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:21:06 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61705 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GZVVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>, Theodore Tso <tytso@mit.edu>
Subject: [ 09/23] ext4: fix duplicated mnt_drop_write call in EXT4_IOC_MOVE_EXT
Date: Thu, 26 Jul 2012 14:19:48 -0700
Message-Id: <20120726211406.703258424@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 331ae4962b975246944ea039697a8f1cadce42bb upstream.

Caused, AFAICS, by mismerge in commit ff9cb1c4eead ("Merge branch
'for_linus' into for_linus_merged")

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -261,7 +261,6 @@ group_extend_out:
 		err = ext4_move_extents(filp, donor_filp, me.orig_start,
 					me.donor_start, me.len, &me.moved_len);
 		mnt_drop_write_file(filp);
-		mnt_drop_write(filp->f_path.mnt);
 
 		if (copy_to_user((struct move_extent __user *)arg,
 				 &me, sizeof(me)))


