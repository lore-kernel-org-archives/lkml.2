Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1AOXXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:23:00 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:33777 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754152Ab1AOXW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:22:56 -0500
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: j47qfzEVM1msRjvHdnBnzrcnesreqkGFDd0uU8a.NTKz_2E
 rNf.cYzu6QsAFVJFyGMppXX70OusMICD4c02E7klKzWCKD9QoAsi_GTV.eME
 s.CAwnjTDn_k..oCYbnj6P7i.bahkiwBm1YM_DdjIjXFgHYGEIdRTcj6YpbL
 pXUahEehbT9neT0lrFKCFinBdlmCsewbYsYdrc3xb_BhmoHLSGtFKReF7dSo
 Aik2HUy5uRPyD0SVEfxewTg78bON332ALi4lyvFqw9wlnlxMLRQJYXJIPol_
 D_VU0ZpgwZxPtoEhfib17m1NbQNzAogaepzrYjmDY7le2TyxKXyeq2ssiNq8
 jimLuGYU_5qukZc8s3TwdwDlV03fzvrsyI1B48w--
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
Subject: [PATCH] dlm: Make DLM depend on CONFIGFS_FS
Date: Sat, 15 Jan 2011 15:16:09 -0800
Message-Id: <1295133371-25990-3-git-send-email-nab@linux-iscsi.org>
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
fs/configfs/Kconfig:1:	symbol CONFIGFS_FS is selected by DLM
fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 fs/dlm/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 2dbb422..1897eb1 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,8 +1,7 @@
 menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
 	depends on EXPERIMENTAL && INET
-	depends on SYSFS && (IPV6 || IPV6=n)
-	select CONFIGFS_FS
+	depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
 	select IP_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
-- 
1.5.6.5

