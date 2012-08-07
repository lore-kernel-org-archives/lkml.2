Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2HGUAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:00:31 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36558 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab2HGT7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 16/41] TTY: tty3270, free tty driver properly
Date: Tue,  7 Aug 2012 21:47:41 +0200
Message-Id: <1344368886-24033-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On module unload, in tty3270_exit, we forgot to free the tty driver.
Add there a call to put_tty_driver.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/tty3270.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 1928f34..215037c 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1800,6 +1800,7 @@ tty3270_exit(void)
 	driver = tty3270_driver;
 	tty3270_driver = NULL;
 	tty_unregister_driver(driver);
+	put_tty_driver(driver);
 	tty3270_del_views();
 }
 
-- 
1.7.10.4


