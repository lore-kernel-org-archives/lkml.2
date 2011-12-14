Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1LNPk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:40:58 -0500
Received: from smtp.altlinux.org ([194.107.17.36]:38432 "EHLO
	smtp.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab1LNPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:40:57 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 10:40:56 EST
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: change permissions for /sys from 0755 to 0555
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Dec 2011 19:34:50 +0400
From: Vitaly Kuznetsov <vitty@altlinux.ru>
Message-ID: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru>
User-Agent: Roundcube Webmail/0.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a misleading difference between /proc and /sys permissions, 
/proc is 0555 and /sys is 0755. But
as it is impossible to create or unlink something in /sys it would be 
nice to have same permissions.

Signed-off-by: Vitaly Kuznetsov <vitty@altlinux.ru>
---
  fs/sysfs/mount.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..9d56fdd 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -36,7 +36,7 @@ struct sysfs_dirent sysfs_root = {
         .s_name         = "",
         .s_count        = ATOMIC_INIT(1),
         .s_flags        = SYSFS_DIR,
-       .s_mode         = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+       .s_mode         = S_IFDIR | S_IRUGO | S_IXUGO,
         .s_ino          = 1,
  };

-- 
1.7.7.4

