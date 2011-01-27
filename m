Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1A0TKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:10:42 -0500
Received: from nm23-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.57]:29511 "HELO
	nm23-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753381Ab1A0TKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:10:39 -0500
X-Yahoo-Newman-Id: 860533.77493.bm@omp1020.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: EpTsGdkVM1mRPZfBNalTNhoKbGqAt6yqVfX9Sufn8FEPWwo
 r1_Oh9r_3AykyCKPbmbM1.Xg_NaLoYWdoSNQTunwqJXpqnV2SLBhA0HFKUhI
 5f_Z42dda.Z0T6V1sTc5l1VaVr3dOSwFulUofF36SK0DboUJkUMyPzlvLeNI
 TZPnik_NbI811Fr9X83LONHTW1BHENlrQ2FncVujdxT9QidRYnP.rLn2RwDT
 _eEKM4G.HTYAsqusISkVw9q5fqt3n1QLWWQ7QV2oOzwUXGbqqTdF0wElORXG
 Rk.cX
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
Subject: [PATCH 3/4] dlm: Make DLM use select CONFIGFS_FS
Date: Thu, 27 Jan 2011 11:10:29 -0800
Message-Id: <1296155430-3796-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
References: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Convert 'depends && SYSFS && CONFIGFS_FS' to 'select CONFIGFS_FS'

Reported-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/dlm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 1897eb1..4f65a50 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,7 +1,7 @@
 menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on EXPERIMENTAL && INET
-	depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
+	depends on EXPERIMENTAL && INET && (IPV6 || IPV6=n)
+	select CONFIGFS_FS
 	select IP_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
-- 
1.7.3.5

