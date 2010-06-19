Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0FSUrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:47:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48232 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0FSUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hAsfHojjn87OjVXiynqqBaF6ZxIL6imHRIeLQdxosSZ6rgr3onmV2+Hdi4hQocSh3a
         cs3kmF1rwLITHYwweggZv/o0uRoi8jv5KjxYF/aHmFdu368KEXPtP2fUc6KYM6WilxVl
         PsWCRT7umbsvdeMmJtpTZ5DREO169YDT1Eo7Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-cifs-client@lists.samba.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/6 v2]cifs Fix warnings variables set but not used
Date: Sat, 19 Jun 2010 13:47:07 -0700
Message-Id: <1276980427-24728-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of the original, to fix whitespace issues
and to maybe do a better job with the issue.

The patch below fixes the warning messages from
gcc 4.6.0 and compiling the kernel.
  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
  CC [M]  fs/cifs/cifs_debug.o

  CC [M]  fs/cifs/dir.o
fs/cifs/dir.c: In function 'cifs_lookup':
fs/cifs/dir.c:641:15: warning: variable 'filp' set but not used

  CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used


 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/cifs/cifssmb.c |    2 +-
 fs/cifs/dir.c     |    3 +--
 fs/cifs/file.c    |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..197349c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4852,7 +4852,7 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
-	char *data_offset;
+	char *data_offset __attribute__((unused));
 	struct file_end_of_file_info *parm_data;
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 391816b..b3d1be2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -638,7 +638,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct cifsTconInfo *pTcon;
 	struct inode *newInode = NULL;
 	char *full_path = NULL;
-	struct file *filp;
 
 	xid = GetXid();
 
@@ -734,7 +733,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			direntry->d_op = &cifs_dentry_ops;
 		d_add(direntry, newInode);
 		if (posix_open)
-			filp = lookup_instantiate_filp(nd, direntry, NULL);
+			lookup_instantiate_filp(nd, direntry, NULL);
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 75541af..73e540b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1312,7 +1312,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	int rc = -EFAULT;
 	int bytes_written = 0;
 	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
+	struct cifsTconInfo *pTcon __attribute__((unused));
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
 
-- 
1.7.1.rc1.21.gf3bd6

