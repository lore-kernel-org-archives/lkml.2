Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1AOXXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:23:06 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:33828 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754152Ab1AOXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:23:03 -0500
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: T1CEYrMVM1mqY46ed0JhBkpcg0YdxJV55Umntl.RaxeCHis
 yyx6mxuwzMqvBOC71WVIIJWKVF6IdDmIpGRUWUm.5VhUWqwMkhGb5f2K3Phq
 1jJNE9PcbC850XZdANkPU3PNSRnq5KcIAFoz37gBEXSuh0_hP2RtrM0pTddq
 uP_8pYkjHXVFRBwdZjVOFDkbgZMMre27nsZUkHI8OThj5LrtAfDrpcQjgyt0
 u0lDibcyUuKXzX8YSTlVztnCsfGfaScTn7iVqmPFl2VFxEU7WPyE8ukmitH3
 WFqJRmYXpH27mfQ--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] ocfs2: Make OCFS2_FS depend on CONFIGFS_FS
Date: Sat, 15 Jan 2011 15:16:10 -0800
Message-Id: <1295133371-25990-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1295133371-25990-1-git-send-email-nab@linux-iscsi.org>
References: <1295133371-25990-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the following kconfig error after changing
CONFIGFS_FS -> select SYSFS:

fs/sysfs/Kconfig:1:error: recursive dependency detected!
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CONFIGFS_FS
fs/configfs/Kconfig:1:	symbol CONFIGFS_FS is selected by OCFS2_FS
fs/ocfs2/Kconfig:1:	symbol OCFS2_FS depends on SYSFS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 fs/ocfs2/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index ab152c0..77a8de5 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,7 +1,6 @@
 config OCFS2_FS
 	tristate "OCFS2 file system support"
-	depends on NET && SYSFS
-	select CONFIGFS_FS
+	depends on NET && SYSFS && CONFIGFS_FS
 	select JBD2
 	select CRC32
 	select QUOTA
-- 
1.5.6.5

