Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2A0Er4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:47:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51899 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2A0Ert (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:49 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 05/29] sysctl: Make the directories have nlink == 1
Date: Thu, 26 Jan 2012 20:49:46 -0800
Message-Id: <1327639810-12760-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19745l3eF6soLRmd+RlXZO1qbgaLm7b0HQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I goofed when I made sysctl directories have nlink == 0.
nlink == 0 means the directory has been deleted.
nlink == 1 meands a directory does not count subdirectories.

Use the default nlink == 1 for sysctl directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 06e6f10..f6aa751 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -253,7 +253,6 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 		inode->i_fop = &proc_sys_file_operations;
 	} else {
 		inode->i_mode |= S_IFDIR;
-		clear_nlink(inode);
 		inode->i_op = &proc_sys_dir_operations;
 		inode->i_fop = &proc_sys_dir_file_operations;
 	}
-- 
1.7.2.5

