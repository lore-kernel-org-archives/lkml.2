Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498Ab2CAV5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:57:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264Ab2CAVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.203.135 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213924.846787322@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@canonical.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [ 16/34] ecryptfs: read on a directory should return EISDIR if not supported
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 1 insertion(+)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -323,6 +323,7 @@ ecryptfs_compat_ioctl(struct file *file,
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
+	.read = generic_read_dir,
 	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = ecryptfs_compat_ioctl,


