Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab1FJV7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:59:22 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:3077 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:59:20 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1307743158!7566437!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext3/ioctl.c: quite sparse warnings about different address spaces
Date: Fri, 10 Jun 2011 14:59:05 -0700
User-Agent: KMail/1.9.9
CC: <linux-ext4@vger.kernel.org>, <jack@suse.cz>, <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101459.06129.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'from' argument for copy_from_user and the 'to' argument for
copy_to_user should both be tagged as __user address space.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index f4090bd..c7f4394 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -285,7 +285,7 @@ group_add_out:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (copy_from_user(&range, (struct fstrim_range *)arg,
+		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 				   sizeof(range)))
 			return -EFAULT;
 
@@ -293,7 +293,7 @@ group_add_out:
 		if (ret < 0)
 			return ret;
 
-		if (copy_to_user((struct fstrim_range *)arg, &range,
+		if (copy_to_user((struct fstrim_range __user *)arg, &range,
 				 sizeof(range)))
 			return -EFAULT;
 
