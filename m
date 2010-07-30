Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0G3Rbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:31:34 -0400
Received: from kroah.org ([198.145.64.141]:51964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab0G3RTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.685331992@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jing Zhang <zj.barak@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [111/165] ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 62e823a2cba18509ee826d775270e8ef9071b5bc upstream (as of v2.6.34-git13)

Signed-off-by: Jing Zhang <zj.barak@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2027,7 +2027,6 @@ repeat:
 
 		for (i = 0; i < ngroups; group++, i++) {
 			struct ext4_group_info *grp;
-			struct ext4_group_desc *desc;
 
 			if (group == ngroups)
 				group = 0;
@@ -2050,7 +2049,6 @@ repeat:
 			}
 
 			ac->ac_groups_scanned++;
-			desc = ext4_get_group_desc(sb, group, NULL);
 			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 &&


