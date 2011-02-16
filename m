Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1BPBaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:30:03 -0500
Received: from kroah.org ([198.145.64.141]:39377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341Ab1BPAVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001437.927412910@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [129/272] ext4: fix uninitialized variable in ext4_register_li_request
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 6c5a6cb998854f3c579ecb2bc1423d302bcb1b76 upstream.

fs/ext4/super.c: In function 'ext4_register_li_request':
fs/ext4/super.c:2936: warning: 'ret' may be used uninitialized in this function

It looks buggy to me, too.

Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2916,7 +2916,7 @@ static int ext4_register_li_request(stru
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_li_request *elr;
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
-	int ret;
+	int ret = 0;
 
 	if (sbi->s_li_request != NULL)
 		return 0;


