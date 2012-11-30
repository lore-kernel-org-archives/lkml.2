Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2K3TGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:06:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:59856 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993100Ab2K3TCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, Tao Ma <boyu.mt@taobao.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 51/54] ext4: remove erroneous ext4_superblock_csum_set() in update_backups()
Date: Fri, 30 Nov 2012 10:56:22 -0800
Message-Id: <20121130185213.043880641@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Ma <boyu.mt@taobao.com>

commit bef53b01faeb791e27605cba1a71ba21364cb23e upstream.

The update_backups() function is used to backup all the metadata
blocks, so we should not take it for granted that 'data' is pointed to
a super block and use ext4_superblock_csum_set to calculate the
checksum there.  In case where the data is a group descriptor block,
it will corrupt the last group descriptor, and then e2fsck will
complain about it it.

As all the metadata checksums should already be OK when we do the
backup, remove the wrong ext4_superblock_csum_set and it should be
just fine.

Reported-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -979,8 +979,6 @@ static void update_backups(struct super_
 		goto exit_err;
 	}
 
-	ext4_superblock_csum_set(sb);
-
 	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
 		struct buffer_head *bh;
 


