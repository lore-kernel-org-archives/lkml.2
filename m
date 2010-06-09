Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab0FISzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:55:09 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab0FISyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:20 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183624.969023160@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:51 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] floppy: remove unnecessary inlines
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-deinline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines are all big enough that is better to let
the compiler decide to inline or not.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/block/floppy.c	2010-06-08 14:54:33.726619979 -0700
+++ b/drivers/block/floppy.c	2010-06-08 14:54:39.187135875 -0700
@@ -899,7 +899,7 @@ static int _lock_fdc(int drive, bool int
 	_lock_fdc(drive, interruptible, __LINE__)
 
 /* unlocks the driver */
-static inline void unlock_fdc(void)
+static void unlock_fdc(void)
 {
 	unsigned long flags;
 
@@ -1224,7 +1224,7 @@ static int need_more_output(void)
 /* Set perpendicular mode as required, based on data rate, if supported.
  * 82077 Now tested. 1Mbps data rate only possible with 82077-1.
  */
-static inline void perpendicular_mode(void)
+static void perpendicular_mode(void)
 {
 	unsigned char perp_mode;
 
@@ -3033,7 +3033,7 @@ static inline int fd_copyin(void __user 
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-static inline const char *drive_name(int type, int drive)
+static const char *drive_name(int type, int drive)
 {
 	struct floppy_struct *floppy;
 
@@ -3103,7 +3103,7 @@ static struct cont_t raw_cmd_cont = {
 	.done		= raw_cmd_done
 };
 
-static inline int raw_cmd_copyout(int cmd, void __user *param,
+static int raw_cmd_copyout(int cmd, void __user *param,
 				  struct floppy_raw_cmd *ptr)
 {
 	int ret;
@@ -3148,7 +3148,7 @@ static void raw_cmd_free(struct floppy_r
 	}
 }
 
-static inline int raw_cmd_copyin(int cmd, void __user *param,
+static int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
 {
 	struct floppy_raw_cmd *ptr;
@@ -3266,7 +3266,7 @@ static int invalidate_drive(struct block
 	return 0;
 }
 
-static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
+static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 			       int drive, int type, struct block_device *bdev)
 {
 	int cnt;
@@ -3365,7 +3365,7 @@ static int ioctl_table[] = {
 	FDTWADDLE
 };
 
-static inline int normalize_ioctl(int *cmd, int *size)
+static int normalize_ioctl(int *cmd, int *size)
 {
 	int i;
 


