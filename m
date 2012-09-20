Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2ITMMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:12:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54938 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2ITMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:33 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Anders Larsen <al@alarsen.net>
Date: Thu, 20 Sep 2012 04:42:02 -0700
Message-Id: <1348141326-23355-21-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19CHaY+oZ6eTL+tTJaDSuUQdwens9gDOmw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 21/25] userns: Convert the qnx4 filesystem to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Anders Larsen <al@alarsen.net>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/qnx4/inode.c |    4 ++--
 init/Kconfig    |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 552e994..5c3c7b0 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -312,8 +312,8 @@ struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
 	    (ino % QNX4_INODES_PER_BLOCK);
 
 	inode->i_mode    = le16_to_cpu(raw_inode->di_mode);
-	inode->i_uid     = (uid_t)le16_to_cpu(raw_inode->di_uid);
-	inode->i_gid     = (gid_t)le16_to_cpu(raw_inode->di_gid);
+	i_uid_write(inode, (uid_t)le16_to_cpu(raw_inode->di_uid));
+	i_gid_write(inode, (gid_t)le16_to_cpu(raw_inode->di_gid));
 	set_nlink(inode, le16_to_cpu(raw_inode->di_nlink));
 	inode->i_size    = le32_to_cpu(raw_inode->di_size);
 	inode->i_mtime.tv_sec   = le32_to_cpu(raw_inode->di_mtime);
diff --git a/init/Kconfig b/init/Kconfig
index 390e629..b9d6be5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -950,7 +950,6 @@ config UIDGID_CONVERTED
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-	depends on QNX4FS_FS = n
 	depends on QNX6FS_FS = n
 	depends on REISERFS_FS = n
 	depends on SQUASHFS = n
-- 
1.7.5.4

