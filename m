Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab1BRQVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:21:42 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64605 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1BRQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=v9jSAcwALP9dtN0lSDjdQG1ckokdUmUNx2XkJ7ssrTiIgLZdutQlEAxUMP4UqhR0d5
         jDmpSk8u5WGyddePLh63PLru7py2dTs/HTWOkGf07qjTVKi+kD9VUpRc5TNf/ziJ66Am
         9Yy4QRc6ohvooq6ceumGmAFpDFfM7707P617M=
MIME-Version: 1.0
Date: Sat, 19 Feb 2011 00:21:38 +0800
Message-ID: <AANLkTinz+X9O-TkOohuTAgA4qq5OXg=yd=03CwzV9W2J@mail.gmail.com>
Subject: [PATCH 2/2] add ->mount function introduction into Documentation/filesystems/vfs.txt
From: Steven Liu <lingjiujianke@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, liuqi <liuqi@thunderst.com>,
        LiDongyang <jerry87905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander Viro,

    add ->mount function introduction into Documentation/filesystems/vfs.txt
    and note that the vfs will replace ->get_sb to ->mount

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 Documentation/filesystems/porting |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/porting
b/Documentation/filesystems/porting
index dfbcd1b..9e20eb5 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -66,6 +66,30 @@ foo_get_sb.
 ---
 [mandatory]

+Newset change of file_system_type method (new mount function ->mount)
+
+*NOTE* linux will replace ->get_sb to ->mount soon.
+the foo_mount function that would return dentry in case of success and negative
+number in case of error (-EINVAL unless you have more informative
error value to
+report).  Call it foo_fill_super().  Now declare
+
+struct dentry *foo_mount(struct file_system_type *fs_type,
+		int flags, const char *dev_name, void *data)
+{
+	return mount_bdev(fs_type, flags, dev_name, data, foo_fill_super);
+}
+
+(or similar with s/bdev/nodev/ or s/bdev/single/, depending on the kind of
+filesystem).
+
+Replace DECLARE_FSTYPE... with explicit initializer and have ->mount set as
+foo_mount.
+
+---
+
+
+[mandatory]
+
 Locking change: ->s_vfs_rename_sem is taken only by cross-directory renames.
 Most likely there is no need to change anything, but if you relied on
 global exclusion between renames for some internal purpose - you need to
-- 
1.7.2



Best Regards
LiuQi
