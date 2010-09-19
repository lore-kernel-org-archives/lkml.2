Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0ISM5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:57:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0ISMys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qJOmYI0yUxNG4Dj1GQpNKff5+jSGXU7488DqtWR5MSXpfGh/STBT3e+508k44KkGfa
         ZsLs5+8m/24zCkqK7VamwfS+WVfSfrWuVqvsFAaxTHPBkwWs/1dBCPBG3YF/AyIymISk
         XddcgjaAut1nmg0MCKrd6uY0jsUcINRzgXzp8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] dio: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:54:44 +0400
Message-Id: <1284900884-24285-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested at all.

 drivers/dio/dio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 55dd88d..d2ede72 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -186,6 +186,7 @@ static int __init dio_init(void)
 	error = device_register(&dio_bus.dev);
 	if (error) {
 		pr_err("DIO: Error registering dio_bus\n");
+		put_device(&dio_bus.dev);
 		return error;
 	}
 
@@ -261,6 +262,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
-- 
1.7.0.4

