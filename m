Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1KFWO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:14:56 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16867 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1KFWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:14:55 -0500
Date: Sun, 6 Nov 2011 23:20:14 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
cc: Neil Brown <neilb@suse.de>
Subject: [PATCH] dm-ioctl: Don't leak memory in target_message() if 'argc'
 is NULL
Message-ID: <alpine.LNX.2.00.1111062318090.5763@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'argc' is NULL we'll jump to the 'out:' label, but this will leak
the memory that 'dm_split_args()' allocated for 'argv', so we should
be jumping to the 'out_argv:' label instead to free up that
memory. This patch does so.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 note: compile tested only.

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 31c2dc2..1ce84ed 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1437,7 +1437,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 
 	if (!argc) {
 		DMWARN("Empty message received.");
-		goto out;
+		goto out_argv;
 	}
 
 	table = dm_get_live_table(md);
-- 
1.7.7.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

