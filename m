Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2DBFmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:42:38 -0400
Received: from smtp20.mail.ru ([94.100.176.173]:41072 "EHLO smtp20.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab2DBFmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:42:37 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] w1: fix slave driver registration error message
Date: Mon,  2 Apr 2012 09:42:22 +0400
Message-Id: <1333345342-12113-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.5.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W1 core prints "Failed to register master driver" if error happens
on registering SLAVE driver. Fix it.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/w1/w1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index b7b5014..c01b5df 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1011,7 +1011,7 @@ static int __init w1_init(void)
 	retval = driver_register(&w1_slave_driver);
 	if (retval) {
 		printk(KERN_ERR
-			"Failed to register master driver. err=%d.\n",
+			"Failed to register slave driver. err=%d.\n",
 			retval);
 		goto err_out_master_unregister;
 	}
-- 
1.7.5.4

