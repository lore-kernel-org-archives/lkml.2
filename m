Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1BPAVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:52 -0500
Received: from kroah.org ([198.145.64.141]:39386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab1BPAVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.023617207@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [130/272] ext4: fix trimming of a single group
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit ca6e909f9bebe709bc65a3ee605ce32969db0452 upstream.

When ext4_trim_fs() is called to trim a part of a single group, the
logic will wrongly set last block of the interval to 'len' instead
of 'first_block + len'. Thus a shorter interval is possibly trimmed.
Fix it.

CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4851,7 +4851,7 @@ int ext4_trim_fs(struct super_block *sb,
 		if (len >= EXT4_BLOCKS_PER_GROUP(sb))
 			len -= (EXT4_BLOCKS_PER_GROUP(sb) - first_block);
 		else
-			last_block = len;
+			last_block = first_block + len;
 
 		if (e4b.bd_info->bb_free >= minlen) {
 			cnt = ext4_trim_all_free(sb, &e4b, first_block,


