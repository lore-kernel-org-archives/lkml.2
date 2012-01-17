Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2AQMRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:17:36 -0500
Received: from smtp.altlinux.org ([194.107.17.36]:36362 "EHLO
	smtp.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2AQMRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:17:35 -0500
From: Vitaly Kuznetsov <vitty@altlinux.ru>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: change permissions for /sys from 0755 to 0555
References: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru>
	<20120105001700.GA26711@kroah.com>
Date: Tue, 17 Jan 2012 12:17:22 +0000
In-Reply-To: <20120105001700.GA26711@kroah.com> (Greg KH's message of "Wed, 4
	Jan 2012 16:17:00 -0800")
Message-ID: <878vl6frql.fsf@vps2.branbackup.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a misleading difference between /proc and /sys permissions, /proc is 0555 and /sys is 0755. But
as it is impossible to create or unlink something in /sys it would be nice to have same permissions.

Signed-off-by: Vitaly Kuznetsov <vitty@altlinux.ru>
---
 fs/sysfs/mount.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..9d56fdd 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -36,7 +36,7 @@ struct sysfs_dirent sysfs_root = {
 	.s_name		= "",
 	.s_count	= ATOMIC_INIT(1),
 	.s_flags	= SYSFS_DIR,
-	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+	.s_mode		= S_IFDIR | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
 };
 
-- 
1.7.3.2
