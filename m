Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab2ITCLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:11:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51729 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2ITCLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:30 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Joel Becker <jlbec@evilplan.org>
Date: Wed, 19 Sep 2012 18:52:21 -0700
Message-Id: <1348105949-25454-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18sBdD5+a8k7RezLfRRG6ThDJ6CsAOt/o0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 19/27] userns: Convert configfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
index ed6310b..33d231c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -950,7 +950,6 @@ config UIDGID_CONVERTED
 	depends on CEPH_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
-	depends on CONFIGFS_FS = n
 	depends on CRAMFS = n
 	depends on ECRYPT_FS = n
 	depends on EFS_FS = n
-- 
1.7.5.4

