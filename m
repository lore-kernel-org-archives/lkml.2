Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2HZAH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:07:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33757 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab2HZAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:07:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
Cc: Joel Becker <jlbec@evilplan.org>
References: <87lih2h6i4.fsf@xmission.com>
Date: Sat, 25 Aug 2012 17:07:14 -0700
In-Reply-To: <87lih2h6i4.fsf@xmission.com> (Eric W. Biederman's message of
	"Sat, 25 Aug 2012 16:54:59 -0700")
Message-ID: <874nnqecst.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18q+eiGq0S3jlwUhlv2ihUtEn5TT7TjoTs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 15/15] userns: Convert configfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Joel Becker <jlbec@evilplan.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/configfs/inode.c |    4 ++--
 init/Kconfig        |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 0074362..a9d35b0 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -79,8 +79,8 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 			return -ENOMEM;
 		/* assign default attributes */
 		sd_iattr->ia_mode = sd->s_mode;
-		sd_iattr->ia_uid = 0;
-		sd_iattr->ia_gid = 0;
+		sd_iattr->ia_uid = GLOBAL_ROOT_UID;
+		sd_iattr->ia_gid = GLOBAL_ROOT_GID;
 		sd_iattr->ia_atime = sd_iattr->ia_mtime = sd_iattr->ia_ctime = CURRENT_TIME;
 		sd->s_iattr = sd_iattr;
 	}
diff --git a/init/Kconfig b/init/Kconfig
index e8612fb..296d48b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -948,7 +948,6 @@ config UIDGID_CONVERTED
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-	depends on CONFIGFS_FS = n
 	depends on CRAMFS = n
 	depends on ECRYPT_FS = n
 	depends on EFS_FS = n
-- 
1.7.5.4

