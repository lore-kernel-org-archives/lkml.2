Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2CLAuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:25 -0400
Received: from 1wt.eu ([62.212.114.60]:63099 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab2CLAsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:50 -0400
Message-Id: <20120312004411.604285381@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [ 07/13] ecryptfs: read on a directory should return EISDIR if not supported
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Whitcroft <apw@canonical.com>

commit 323ef68faf1bbd9b1e66aea268fd09d358d7e8ab upstream.

read() calls against a file descriptor connected to a directory are
incorrectly returning EINVAL rather than EISDIR:

  [EISDIR]
    [XSI] [Option Start] The fildes argument refers to a directory and the
    implementation does not allow the directory to be read using read()
    or pread(). The readdir() function should be used instead. [Option End]

This occurs because we do not have a .read operation defined for
ecryptfs directories.  Connect this up to generic_read_dir().

BugLink: http://bugs.launchpad.net/bugs/719691
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
---
 fs/ecryptfs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index d8adc51..3015389 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -323,6 +323,7 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
+	.read = generic_read_dir,
 	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = ecryptfs_compat_ioctl,
-- 
1.7.2.1.45.g54fbc



