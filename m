Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1AOXW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:22:59 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:33756 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754146Ab1AOXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:22:49 -0500
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 6dseeNoVM1nlSkjUbcIR83KjNOV6LlhVzhRj1Xp.1TQ.mqU
 pwBfZCR5aw3FHnK_3n3n0sC.bSMj5f4uqAC9JpZN7g4yvO4JpL9gSJBbfMi6
 h.Vm_yVga8P6XDhRCVmwec87aoXKr0JqoVIYEfd9jivB3rNKmAgkWn_S6ewy
 JZF4_irsM0JiwnEmp9pluClr4B4NWh6zUqIZBT84FGpVRf98n.iMZYMRcNHP
 _OZIqzHFuAVhGguuTG7ly_enrRefiz9DDdPgx8JPTDerX1tHIuq1Ae.GQgzU
 YdZ468qScSQkLUlvSyzKs8IeX7QMwoku2Mw4APJhTu3nVHNSh1E9tt.e46Qy
 qrccy0ihR8RyKogyHTUm0.qv1lD2QbsSUM89cfro-
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
Subject: [PATCH] net: Make NETCONSOLE_DYNAMIC depend on CONFIGFS_FS
Date: Sat, 15 Jan 2011 15:16:08 -0800
Message-Id: <1295133371-25990-2-git-send-email-nab@linux-iscsi.org>
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
fs/configfs/Kconfig:1:	symbol CONFIGFS_FS is selected by NETCONSOLE_DYNAMIC
drivers/net/Kconfig:3390:	symbol NETCONSOLE_DYNAMIC depends on SYSFS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/net/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4c8bfc9..16fe4f9 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3389,8 +3389,7 @@ config NETCONSOLE
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
-	depends on NETCONSOLE && SYSFS
-	select CONFIGFS_FS
+	depends on NETCONSOLE && SYSFS && CONFIGFS_FS
 	help
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)
-- 
1.5.6.5

