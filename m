Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1ABHWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:34804 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab1ABHWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 072/260] Input: i8042 - fix device removal on unload
Date: Sun,  2 Jan 2011 02:16:08 -0500
Message-Id: <1293952756-15010-73-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:25.0976 (UTC) FILETIME=[AA7DB580:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit af045b86662f17bf130239a65995c61a34f00a6b upstream.

We need to call platform_device_unregister(i8042_platform_device)
before calling platform_driver_unregister() because i8042_remove()
resets i8042_platform_device to NULL. This leaves the platform device
instance behind and prevents driver reload.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=16613

Reported-by: Seryodkin Victor <vvscore@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/input/serio/i8042.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 6440a8f..f3c2bb7 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1483,8 +1483,8 @@ static int __init i8042_init(void)
 
 static void __exit i8042_exit(void)
 {
-	platform_driver_unregister(&i8042_driver);
 	platform_device_unregister(i8042_platform_device);
+	platform_driver_unregister(&i8042_driver);
 	i8042_platform_exit();
 
 	panic_blink = NULL;
-- 
1.7.3.3

