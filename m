Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2HTG6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:58:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48868 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2HTG61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:58:27 -0400
MIME-Version: 1.0
Date: Mon, 20 Aug 2012 14:58:26 +0800
Message-ID: <CACV3sbKA6pjcjc+Wr-w+JNtzJfrJS=6tcMKgDzWMaZ_AV1NQ3A@mail.gmail.com>
Subject: [PATCH] pstore: add missed platform_device_unregister
From: Jovi Zhang <bookjovi@gmail.com>
To: tony.luck@intel.com, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 152373a6262045d19023cf45de84ad3c69316a45 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Mon, 20 Aug 2012 14:20:01 +0800
Subject: [PATCH] pstore: add missed platform_device_unregister

we need unregister platform device when module exit, add it.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 fs/pstore/ram.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 0b311bc..adb218a 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -537,6 +537,7 @@ postcore_initcall(ramoops_init);
 static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
+	platform_device_unregister(dummy);
 	kfree(dummy_data);
 }
 module_exit(ramoops_exit);
-- 
1.7.9.7
