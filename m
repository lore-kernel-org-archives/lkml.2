Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2JOQyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:54:47 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:49819 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753014Ab2JOQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:54:46 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>,
        Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH] rename ccg init and exit functions to conventional names
Date: Mon, 15 Oct 2012 18:54:41 +0200
Message-Id: <1350320081-22547-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.124.86.170 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Previous names of init and exit functions "init" and "cleanup" are unconventional and are not friendly for source navigation with tags.
New names "ccg_init" and "ccg_exit" are conveninal and source navigation friendly.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 drivers/staging/ccg/ccg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
index 93e1e2f..ffc5f73 100644
--- a/drivers/staging/ccg/ccg.c
+++ b/drivers/staging/ccg/ccg.c
@@ -1239,7 +1239,7 @@ static int ccg_create_device(struct ccg_dev *dev)
 }
 
 
-static int __init init(void)
+static int __init ccg_init(void)
 {
 	struct ccg_dev *dev;
 	int err;
@@ -1280,13 +1280,13 @@ static int __init init(void)
 
 	return err;
 }
-module_init(init);
+module_init(ccg_init);
 
-static void __exit cleanup(void)
+static void __exit ccg_exit(void)
 {
 	usb_composite_unregister(&ccg_usb_driver);
 	class_destroy(ccg_class);
 	kfree(_ccg_dev);
 	_ccg_dev = NULL;
 }
-module_exit(cleanup);
+module_exit(ccg_exit);
-- 
1.7.9.5

