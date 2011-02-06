Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1BFUjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:39:33 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:46432 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753951Ab1BFUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:39:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBALKVTk1Ld/sX/2dsb2JhbAAMhAucK7BIjyqEZHYEhHqMMQ
X-IronPort-AV: E=Sophos;i="4.60,434,1291611600"; 
   d="scan'208";a="90726795"
Message-ID: <4D4F0701.5060602@teksavvy.com>
Date: Sun, 06 Feb 2011 15:39:29 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <greg@kroah.com>
Subject: PATCH: drivers/staging/lirc/lirc_serial.c: use IS_ERR()
Content-Type: multipart/mixed;
 boundary="------------040005080103010501000803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040005080103010501000803
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The lirc_serial.c module has never worked with ordinary homebrew
serial blaster hardware, and leaks memory when this is attempted.

Fix it by replacing incorrect usage of PTR_ERR() with IS_ERR().
(patch is inline and also attached to bypass mailer issues).

Signed-off-by: Mark Lord <mlord@pobox.com>

--- linux-2.6.37/drivers/staging/lirc/lirc_serial.c	2011-01-04
19:50:19.000000000 -0500
+++ linux/drivers/staging/lirc/lirc_serial.c	2011-02-06 15:33:49.854453928 -0500
@@ -966,7 +966,7 @@
 	if (n % sizeof(int) || count % 2 == 0)
 		return -EINVAL;
 	wbuf = memdup_user(buf, n);
-	if (PTR_ERR(wbuf))
+	if (IS_ERR(wbuf))
 		return PTR_ERR(wbuf);
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	if (type == LIRC_IRDEO) {

--------------040005080103010501000803
Content-Type: text/x-patch;
 name="lirc_serial_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lirc_serial_fix.patch"

--- linux-2.6.37/drivers/staging/lirc/lirc_serial.c.orig	2011-01-04 19:50:19.000000000 -0500
+++ linux/drivers/staging/lirc/lirc_serial.c	2011-02-06 15:33:49.854453928 -0500
@@ -966,7 +966,7 @@
 	if (n % sizeof(int) || count % 2 == 0)
 		return -EINVAL;
 	wbuf = memdup_user(buf, n);
-	if (PTR_ERR(wbuf))
+	if (IS_ERR(wbuf))
 		return PTR_ERR(wbuf);
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	if (type == LIRC_IRDEO) {

--------------040005080103010501000803--
