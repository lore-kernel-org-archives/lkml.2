Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0LIW1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:27:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53755 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750796Ab0LIW1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:27:38 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/xxWs2l+Px+YDcMvQgG1piRpBZXJny+sBS64g8Nw
	uL+guat+CQnFPo
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Dan Williams <dcbw@redhat.com>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] serial/usb_wwan: Add missing uaccess.h / fix build failure
Date: Thu,  9 Dec 2010 23:27:35 +0100
Message-Id: <1291933655-23130-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure[1] by adding the missing uaccess.h needed
for copy_from_user and copy_to_user

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20101209

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/3607218/
Used Config:
s3c2410_defconfig

drivers/usb/serial/usb_wwan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 660b7ca..b004b2a 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -31,6 +31,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/serial.h>
-- 
1.7.2.2

