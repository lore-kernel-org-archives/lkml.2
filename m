Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0GIGvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:51:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49933 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0GIGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=YdNvTHZBS50UWtyuLVdbxVKwBt2GXNUzc3JKFta+ZzgmJkL2NvRiSuVUsnosl0I2VW
         I1HTVz9Gynr2JLTwTXt7y7NyhrxMUvPfC8l71YsVqo0fTQ1xStFvA3vHKnUxivvmzRRS
         jcQBL/IwF6XxdEWqNZ0CP6nGoxxgbw4JADVDM=
Subject: [PATCH] tools/usb: Add Makefile
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: m.nazarewicz@samsung.com, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 02:51:01 -0400
Message-ID: <1278658261.21495.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds a Makefile for building 'testusb'.

I am wondering if it should really still use usbdevfs (deprecated), instead of usbfs?

Thanks,
Davidlohr

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 tools/usb/Makefile |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 tools/usb/Makefile

diff --git a/tools/usb/Makefile b/tools/usb/Makefile
new file mode 100644
index 0000000..45b5cab
--- /dev/null
+++ b/tools/usb/Makefile
@@ -0,0 +1,14 @@
+# Makefile for building 'usbtest'
+
+CC = $(CROSS_COMPILE)gcc
+PTHREAD_LIBS = -lpthread
+WARNINGS = -Wall
+WARNINGS := $(WARNINGS) -Wextra
+CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
+
+all:
+	$(CC) $(CFLAGS) -o testusb testusb.c
+
+clean:
+	$(RM) testusb
+
-- 
1.7.0.4

