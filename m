Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0GMJut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:50:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50177 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0GMJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=QdgXwlp2GwN4HZ8w85pWh9VhZO54HaboXycsxa1/RGEZLyDDLFuAY5XlE38tBz2NSp
         QszM9pqKJyEtIltt9TuXZ8dzRSNKhtIjEcfrMDY5urxUzBNZWxWu2+WP/aiFY/rwOAtq
         9q28BXhd+WBIafDwV5FhdwwOmPQ3yv2dytQA4=
Subject: [PATCH RESEND] tools/usb: Add Makefile
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: m.nazarewicz@samsung.com, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 05:50:42 -0400
Message-ID: <1279014642.18280.2.camel@cowboy>
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


