Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2KSPR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:17:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35521 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2KSPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:17:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:38 -0800
Message-Id: <1353337961-12962-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/egp7hacbC2z6q+EUar5EuTTeQB5IAMPc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 13/16] userns: Allow unprivilged mounts of proc and sysfs
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- The context in which proc and sysfs are mounted have no
  effect on the the uid/gid of their files so no conversion is
  needed except allowing the mount.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/root.c   |    1 +
 fs/sysfs/mount.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index f2f2511..c6e9fac 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -145,6 +145,7 @@ static struct file_system_type proc_fs_type = {
 	.name		= "proc",
 	.mount		= proc_mount,
 	.kill_sb	= proc_kill_sb,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 
 void __init proc_root_init(void)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 71eb7e2..db940a9 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -149,6 +149,7 @@ static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.mount		= sysfs_mount,
 	.kill_sb	= sysfs_kill_sb,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 
 int __init sysfs_init(void)
-- 
1.7.5.4

