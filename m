Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2AOTgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 14:36:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23147 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2AOTgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 14:36:48 -0500
Date: Sun, 15 Jan 2012 20:36:46 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: dm-devel@redhat.com
cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>
Subject: [PATCH] drivers/md/dm-ioctl.c::target_message(): don't leak 'argv'
 mem
Message-ID: <alpine.LNX.2.00.1201152034410.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, after allocating memory for 'argv' via dm_split_args(...), we take
the true branch of 'if (!argc)', we'll jump to the 'out:' label and
neglect to free the memory we allocated. We should instead jump to the
'out_argv:' label in that case as far as I can tell.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 Compile tested only.

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
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

