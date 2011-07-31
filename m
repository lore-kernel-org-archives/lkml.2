Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1GaGoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 02:44:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:51441 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1GaGoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 02:44:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000_proc needs asm/io.h for inw/outw on sparc
Date: Sun, 31 Jul 2011 02:44:05 -0400
Message-Id: <1312094645-30290-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen during an allmodconfig build for sparc:

  CC [M]  drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.o
In file included from drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:26:
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_read_reg':
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80: error: implicit declaration of function 'inw'
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_write_reg':
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86: error: implicit declaration of function 'outw'

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index 627a98b..9e728b3 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -22,6 +22,7 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/netdevice.h>
+#include <asm/io.h>
 #include <asm/uaccess.h>
 #include "ft1000.h"
 
-- 
1.7.6

