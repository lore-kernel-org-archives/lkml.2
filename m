Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0J0ESc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:18:32 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:47308 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0J0ES1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:18:27 -0400
X-ASG-Debug-ID: 1288153106-085b31360001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC7A809.1070607@fusionio.com>
Date: Tue, 26 Oct 2010 22:18:17 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fix for loop warning
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] fix for loop warning
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1288153106
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.1276 1.0000 -1.2298
X-Barracuda-Spam-Score: -1.23
X-Barracuda-Spam-Status: No, SCORE=-1.23 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44850
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One-liner fix for a warning regression introduced with the
loop changes pulled for 2.6.37-rc1

Please pull.

The following changes since commit 9db59aff3fb32b05a7e2464dd543de03b2b3cebc:

  loop: Properly clear sysfs in autoclear mode (2010-10-26 22:13:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/linux-2.6-block.git for-linus

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1e5284e..450c958 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1049,9 +1049,9 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	if (bdev)
 		invalidate_bdev(bdev);
 	set_capacity(lo->lo_disk, 0);
-	loop_sysfs_exit(lo);
 	if (bdev) {
 		bd_set_size(bdev, 0);
+		loop_sysfs_exit(lo);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}

-- 
Jens Axboe

