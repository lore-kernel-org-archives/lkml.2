Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2DTU2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:28:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:43493 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2DTU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:28:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1334953719!4381908!5
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog_dev: include private header to pickup global symbol prototypes
Date: Fri, 20 Apr 2012 13:28:24 -0700
User-Agent: KMail/1.9.9
CC: <linux-watchdog@vger.kernel.org>, <wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204201328.25057.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the private watchdog_dev.h header to pickup the prototypes for the
watchdog_dev_register/unregister functions.

This quiets the following sparse warnings:

warning: symbol 'watchdog_dev_register' was not declared. Should it be static?
warning: symbol 'watchdog_dev_unregister' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 8558da9..6c18a58 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -42,6 +42,8 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
+#include "watchdog_dev.h"
+
 /* make sure we only register one /dev/watchdog device */
 static unsigned long watchdog_dev_busy;
 /* the watchdog device behind /dev/watchdog */
