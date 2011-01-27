Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1A0TKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:10:38 -0500
Received: from nm6.bullet.mail.ne1.yahoo.com ([98.138.90.69]:23707 "HELO
	nm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753326Ab1A0TKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:10:35 -0500
X-Yahoo-Newman-Id: 283839.53578.bm@omp1038.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: sNmj5o8VM1lCELn90.2yL2ZgorHqXffswlZilsf7iO.dAyY
 _bOU98SX4GhEJAdLZ6ArLydX.p1KQ2RdbsStRvsm6bLP8zQCzU8ARNTGR9zp
 iF2sTTm.DKXP9fOYH6c8MyIxHvrEHFi9P9SySMvOrlYGyzhHdIDOJqQVJULi
 MExXcdhhBHw5c5WGuzshJD0wCue4MZMGPRy0_i5tOORFAYSqKOLUtCSEJhkW
 DdXKBYRz997ai0MoIPIBKB4R6hVbP_woMop3feOcB7JFYxSOPlF7Fx2kRBw-
 -
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/4] net: Make NETCONSOLE_DYNAMIC use select CONFIGFS_FS
Date: Thu, 27 Jan 2011 11:10:28 -0800
Message-Id: <1296155430-3796-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
References: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Convert 'depends && SYSFS && CONFIGFS_FS' to 'select CONFIGFS_FS'

Reported-by: Joel Becker <jlbec@evilplan.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/net/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 0382332..3d23ebb 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3389,7 +3389,8 @@ config NETCONSOLE
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
-	depends on NETCONSOLE && SYSFS && CONFIGFS_FS
+	depends on NETCONSOLE
+	select CONFIGFS_FS
 	help
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)
-- 
1.7.3.5

