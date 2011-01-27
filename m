Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1A0TKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:10:46 -0500
Received: from nm13-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.48]:42578 "HELO
	nm13-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753445Ab1A0TKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:10:43 -0500
X-Yahoo-Newman-Id: 623930.17902.bm@omp1014.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: sd30To8VM1mxpivDsrvqwChyf87AtGGhjqLERaJEhIqWq_2
 LMwH2CTKzGNxMrJGzlzeu8NCVB8ZNDYDo7qMhGHgUfJU1NTZKaS79.Ec9cmh
 R6WGSMSBF_mP6ZlOGZrWEipKlMuWDHoXNcYOv8j4HoIms4UgA5_AoiHi_8VB
 83QtWavDG78Y.bcwzikGgq2A7GJVTjB9h3nPUaCA8RbJoW9i1jPSe8dpCNy9
 JVIrv4kjn9gIg1_X4QybZWSAgN2aTI8RSVXeevRN386Q_uhXyTC3hZK4-
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
Subject: [PATCH 4/4] ocfs2: Make OCFS2_FS use select CONFIGFS_FS
Date: Thu, 27 Jan 2011 11:10:30 -0800
Message-Id: <1296155430-3796-5-git-send-email-nab@linux-iscsi.org>
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
 fs/ocfs2/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 77a8de5..bb03131 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,6 +1,7 @@
 config OCFS2_FS
 	tristate "OCFS2 file system support"
-	depends on NET && SYSFS && CONFIGFS_FS
+	depends on NET
+	select CONFIGFS_FS
 	select JBD2
 	select CRC32
 	select QUOTA
-- 
1.7.3.5

