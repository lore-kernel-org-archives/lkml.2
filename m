Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1ANHSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:18:53 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49327 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab1ANHSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:18:47 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] tty/tty_io.c: fix compilation warning
Date: Fri, 14 Jan 2011 12:48:17 +0530
Message-ID: <1294989497-2531-1-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following compilation warning:
tty/tty_io.c:3309: warning: ignoring return value of 'device_create_file',
declared with attribute warn_unused_result

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/tty/tty_io.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 464d09d..b558f03 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3291,6 +3291,8 @@ void console_sysfs_notify(void)
  */
 int __init tty_init(void)
 {
+	int ret = 0;
+
 	cdev_init(&tty_cdev, &tty_fops);
 	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
@@ -3306,11 +3308,11 @@ int __init tty_init(void)
 	if (IS_ERR(consdev))
 		consdev = NULL;
 	else
-		device_create_file(consdev, &dev_attr_active);
+		ret = device_create_file(consdev, &dev_attr_active);
 
 #ifdef CONFIG_VT
 	vty_init(&console_fops);
 #endif
-	return 0;
+	return ret;
 }
 
-- 
1.7.2.2

