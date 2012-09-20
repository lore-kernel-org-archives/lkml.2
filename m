Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2ITMMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:12:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41420 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab2ITMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:33 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:52 -0700
Message-Id: <1348141326-23355-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+tC8MdrVHFUBa37cviDmQskIH7J5jzLdI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 11/25] userns: Convert efs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/efs/inode.c |    4 ++--
 init/Kconfig   |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index bc84f36..f3913eb 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -97,8 +97,8 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
     
 	inode->i_mode  = be16_to_cpu(efs_inode->di_mode);
 	set_nlink(inode, be16_to_cpu(efs_inode->di_nlink));
-	inode->i_uid   = (uid_t)be16_to_cpu(efs_inode->di_uid);
-	inode->i_gid   = (gid_t)be16_to_cpu(efs_inode->di_gid);
+	i_uid_write(inode, (uid_t)be16_to_cpu(efs_inode->di_uid));
+	i_gid_write(inode, (gid_t)be16_to_cpu(efs_inode->di_gid));
 	inode->i_size  = be32_to_cpu(efs_inode->di_size);
 	inode->i_atime.tv_sec = be32_to_cpu(efs_inode->di_atime);
 	inode->i_mtime.tv_sec = be32_to_cpu(efs_inode->di_mtime);
diff --git a/init/Kconfig b/init/Kconfig
index 6120bae..51084b0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -941,7 +941,6 @@ config UIDGID_CONVERTED
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-	depends on EFS_FS = n
 	depends on EXOFS_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
-- 
1.7.5.4

