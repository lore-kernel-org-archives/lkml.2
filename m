Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1IWW0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:26:37 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:56810 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1IWW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:26:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1316816791!11235038!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4/ioctl.c: copy_{from,to}_user expect __user pointers
Date: Fri, 23 Sep 2011 15:25:54 -0700
User-Agent: KMail/1.9.9
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231525.54301.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the sparse noise:

warning: incorrect type in argument 2 (different address spaces)
   expected void const [noderef] <asn:1>*from
   got struct fstrim_range *<noident>
warning: incorrect type in argument 1 (different address spaces)
   expected void [noderef] <asn:1>*to
   got struct fstrim_range *<noident>

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f18bfe3..43759b1 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -348,7 +348,7 @@ mext_out:
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
 
-		if (copy_from_user(&range, (struct fstrim_range *)arg,
+		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 		    sizeof(range)))
 			return -EFAULT;
 
@@ -358,7 +358,7 @@ mext_out:
 		if (ret < 0)
 			return ret;
 
-		if (copy_to_user((struct fstrim_range *)arg, &range,
+		if (copy_to_user((struct fstrim_range __user *)arg, &range,
 		    sizeof(range)))
 			return -EFAULT;
 
