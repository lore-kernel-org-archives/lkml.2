Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2ITLoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:44:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51818 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2ITLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:43:08 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 20 Sep 2012 04:41:50 -0700
Message-Id: <1348141326-23355-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ucDVgIeMW/yKzWjFdrtejvaB6c1FQBPc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 09/25] userns: Convert cramfs to use kuid/kgid where appropriate
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
 fs/cramfs/inode.c |    4 ++--
 init/Kconfig      |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 28cca01..c6c3f91 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -90,8 +90,8 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 	}
 
 	inode->i_mode = cramfs_inode->mode;
-	inode->i_uid = cramfs_inode->uid;
-	inode->i_gid = cramfs_inode->gid;
+	i_uid_write(inode, cramfs_inode->uid);
+	i_gid_write(inode, cramfs_inode->gid);
 
 	/* if the lower 2 bits are zero, the inode contains data */
 	if (!(inode->i_ino & 3)) {
diff --git a/init/Kconfig b/init/Kconfig
index d9bb344..5f846b5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -941,7 +941,6 @@ config UIDGID_CONVERTED
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-	depends on CRAMFS = n
 	depends on ECRYPT_FS = n
 	depends on EFS_FS = n
 	depends on EXOFS_FS = n
-- 
1.7.5.4

