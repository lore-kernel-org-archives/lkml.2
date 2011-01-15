Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1AOVLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 16:11:00 -0500
Received: from nm5-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.68]:39688 "HELO
	nm5-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753378Ab1AOVK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 16:10:59 -0500
X-Yahoo-Newman-Id: 359458.31061.bm@omp1019.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: AGllb4gVM1kynlwZaPB6UBZW5XVuDtbTVSt5oYibz5o4H4g
 8vl4XH9p1Mtg1JAR2pXSZ48lZMqjzVLJ50INOPHeR.pjXd33M.l9.4NqHUSo
 S7ufhsmpnWlaBIs4pUlJhpzQmFM6KZNAlyi1NdChLOJmxSRZMBzgZRicGGI1
 QCxTUmcs7pGtgKVjfYxZ9q1z46L6JKVaEM86_0B3AyokElv7PgrRcYSqZy1R
 UPzapl6XCx9orhpN.PWtbPlzRV.ntZ9sHsqIWGzAIh3FLZ7vXrIFGej0OZrR
 SanN6jEScFRa3z0KqxR08H2B7x2lrg6jKhpse3_GF7AHLj2ZCiqQixF0QeFe
 C1F7pY2177QqyYw7Ro9EGERKK4MkPZz9JDp7n.Ut_E_A-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] configfs: change depends -> select SYSFS
Date: Sat, 15 Jan 2011 13:10:51 -0800
Message-Id: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

The following patch should be included for 38-rc1 to fix a rdd
reported linux-next kbuild warning introduced by TARGET_CORE
using 'select CONFIGFS_FS' from over the holidays, that was not
included with the initial target merge yesterday.

Thanks!

----------------------------------------------------------------

This patch changes configfs to select SYSFS to fix the following:

warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

This patch also fixes whitespace breakage in the 'help' section.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/configfs/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/Kconfig b/fs/configfs/Kconfig
index 13587cc..0e4bd23 100644
--- a/fs/configfs/Kconfig
+++ b/fs/configfs/Kconfig
@@ -1,11 +1,11 @@
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem"
-	depends on SYSFS
+	select SYSFS
 	help
-	  configfs is a ram-based filesystem that provides the converse
-	  of sysfs's functionality. Where sysfs is a filesystem-based
-	  view of kernel objects, configfs is a filesystem-based manager
-	  of kernel objects, or config_items.
+	configfs is a RAM-based filesystem that provides the converse
+	of sysfs's functionality. Where sysfs is a filesystem-based
+	view of kernel objects, configfs is a filesystem-based manager
+	of kernel objects, or config_items.
 
-	  Both sysfs and configfs can and should exist together on the
-	  same system. One is not a replacement for the other.
+	Both sysfs and configfs can and should exist together on the
+	same system. One is not a replacement for the other.
-- 
1.7.3.5

