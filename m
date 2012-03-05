Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab2CEOFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:05:08 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34695 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2CENxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 04/68] TTY: remove minor_num from tty_driver
Date: Mon,  5 Mar 2012 14:51:51 +0100
Message-Id: <1330955575-26641-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was added back in 2004 and never used for anything real. Remove the
only assignment in the tree as well.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/pti.c         |    1 -
 include/linux/tty_driver.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 471ff4c..9a35db3 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -920,7 +920,6 @@ static int __init pti_init(void)
 	pti_tty_driver->name			= TTYNAME;
 	pti_tty_driver->major			= 0;
 	pti_tty_driver->minor_start		= PTITTY_MINOR_START;
-	pti_tty_driver->minor_num		= PTITTY_MINOR_NUM;
 	pti_tty_driver->num			= PTITTY_MINOR_NUM;
 	pti_tty_driver->type			= TTY_DRIVER_TYPE_SYSTEM;
 	pti_tty_driver->subtype			= SYSTEM_TYPE_SYSCONS;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 6e65493..e064f17 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -299,7 +299,6 @@ struct tty_driver {
 	int	name_base;	/* offset of printed name */
 	int	major;		/* major device number */
 	int	minor_start;	/* start of minor device number */
-	int	minor_num;	/* number of *possible* devices */
 	int	num;		/* number of devices allocated */
 	short	type;		/* type of tty driver */
 	short	subtype;	/* subtype of tty driver */
-- 
1.7.9.2


