Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2AWEZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 23:25:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:49819 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2AWEZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 23:25:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: arnd@arndb.de, greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] c2port: fix build error for duramar2150 due to missing header.
Date: Sun, 22 Jan 2012 23:24:15 -0500
Message-Id: <1327292655-30565-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file needs the basic headers for resource management,
otherwise we will see this build error:

 CC [M]  drivers/misc/c2port/c2port-duramar2150.o
 drivers/misc/c2port/c2port-duramar2150.c: In function ‘duramar2150_c2port_init’:
 drivers/misc/c2port/c2port-duramar2150.c:125:2: error: implicit declaration of function ‘request_region’ [-Werror=implicit-function-declaration]
 drivers/misc/c2port/c2port-duramar2150.c:139:2: error: implicit declaration of function ‘release_region’ [-Werror=implicit-function-declaration]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/misc/c2port/c2port-duramar2150.c b/drivers/misc/c2port/c2port-duramar2150.c
index 778fc3f..5484301 100644
--- a/drivers/misc/c2port/c2port-duramar2150.c
+++ b/drivers/misc/c2port/c2port-duramar2150.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/ioport.h>
 #include <linux/c2port.h>
 
 #define DATA_PORT	0x325
-- 
1.7.7.2

