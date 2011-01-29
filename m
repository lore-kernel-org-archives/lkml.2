Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1A2TJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:09:37 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:49552 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1A2TJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:09:33 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 15/16] vfs: enable O_PATH descriptor for few syscalls
Date: Sun, 30 Jan 2011 00:38:18 +0530
Message-Id: <1296328099-23263-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enable O_PATH descriptor for dup*/chmod/chown/stat

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/fcntl.c |    2 +-
 fs/open.c  |    4 ++--
 fs/stat.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ba4b564..b052600 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -131,7 +131,7 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 SYSCALL_DEFINE1(dup, unsigned int, fildes)
 {
 	int ret = -EBADF;
-	struct file *file = fget(fildes);
+	struct file *file = fget_lenient(fildes);
 
 	if (file) {
 		ret = get_unused_fd();
diff --git a/fs/open.c b/fs/open.c
index 7dbde0f..328a76e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -447,7 +447,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, mode_t, mode)
 	int err = -EBADF;
 	struct iattr newattrs;
 
-	file = fget(fd);
+	file = fget_lenient(fd);
 	if (!file)
 		goto out;
 
@@ -611,7 +611,7 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 	int error = -EBADF;
 	struct dentry * dentry;
 
-	file = fget(fd);
+	file = fget_lenient(fd);
 	if (!file)
 		goto out;
 
diff --git a/fs/stat.c b/fs/stat.c
index d5c61cf..d88a96a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
-	struct file *f = fget(fd);
+	struct file *f = fget_lenient(fd);
 	int error = -EBADF;
 
 	if (f) {
-- 
1.7.1

