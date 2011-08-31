Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1HaTZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:25:32 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:42893 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1HaTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:25:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/4] TTY: serial, fix build of some drivers
Date: Wed, 31 Aug 2011 21:24:58 +0200
Message-Id: <1314818699-10873-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting build errors such as:
.../tty/serial/max3107.c: In function ‘put_data_to_circ_buf’:
.../tty/serial/max3107.c:149:2: error: implicit declaration of function ‘tty_insert_flip_string’

Those drivers need to include linux/tty_flip.h. The question is
whether we want to fix them at all. As they are broken for some time
already and nobody noticed...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/max3107.c  |    1 +
 drivers/tty/serial/timbuart.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/max3107.c b/drivers/tty/serial/max3107.c
index a50f406..a33ff77 100644
--- a/drivers/tty/serial/max3107.c
+++ b/drivers/tty/serial/max3107.c
@@ -35,6 +35,7 @@
 #include <linux/spi/spi.h>
 #include <linux/freezer.h>
 #include <linux/module.h>
+#include <linux/tty_flip.h>
 #include "max3107.h"
 
 static const struct baud_table brg26_ext[] = {
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index e213535..3a4da87 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -28,6 +28,7 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/tty_flip.h>
 
 #include "timbuart.h"
 
-- 
1.7.6.1


