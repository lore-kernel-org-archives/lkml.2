Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0HUHVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:21:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47686 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0HUHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:21:32 -0400
From: Sachin Sant <sachinp@in.ibm.com>
To: schwidefsky@de.ibm.com
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        dmitry.torokhov@gmail.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Date: Sat, 21 Aug 2010 12:51:26 +0530
Message-Id: <20100821072126.8965.41003.sendpatchset@localhost.localdomain>
Subject: [-next PATCH] Fix s390 keyboard driver build break
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next 20100820 fails to build on s390 with 

drivers/s390/char/keyboard.c: In function 'kbd_keycode':
drivers/s390/char/keyboard.c:308: error: too many arguments to function 'handle_sysrq'
make[2]: *** [drivers/s390/char/keyboard.o] Error 1

The following commit changed handle_sysrq() function to accept single argument. 

commit a821bafce37b26499e2bfbf2e6b96b0636efc014
Input: sysrq - drop tty argument form handle_sysrq()

Adapt the code accordingly to fix the build break.

Signed-off-by: Sachin Sant <sachinp@in.ibm.com>
---

diff -Naurp next20100820/drivers/s390/char/keyboard.c next20100820-new//drivers/s390/char/keyboard.c
--- next20100820/drivers/s390/char/keyboard.c	2010-08-16 06:11:37.000000000 +0530
+++ next20100820-new//drivers/s390/char/keyboard.c	2010-08-21 11:55:25.000000000 +0530
@@ -305,7 +305,7 @@ kbd_keycode(struct kbd_data *kbd, unsign
 		if (kbd->sysrq) {
 			if (kbd->sysrq == K(KT_LATIN, '-')) {
 				kbd->sysrq = 0;
-				handle_sysrq(value, kbd->tty);
+				handle_sysrq(value);
 				return;
 			}
 			if (value == '-') {
