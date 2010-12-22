Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0LVMz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:55:28 -0500
Received: from smtpout01.highway.telekom.at ([195.3.96.112]:25030 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417Ab0LVMz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:55:27 -0500
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: [PATCH] USB: DL100B webmail notifier: initialize return value
Date: Wed, 22 Dec 2010 13:55:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2+; KDE/4.4.4; x86_64; ; )
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221355.24509@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melchior FRANZ <mfranz@aon.at>

If case of an unknown usb_device_id->driver_info (which could only
occur if the info got corrupted somewhere outside the usbled driver),
a debug message depended on an uninitialized value. This was harmless,
but ugly, and gets fixed with this patch.

Signed-off-by: Melchior FRANZ <mfranz@aon.at>
---

@Greg:
Argh ... sorry about that. The build system didn't warn me, not even
with EXTRA_CFLAGS=-W. And cppcheck ignored the problem as well. This
must be a plot to damage my reputation!  :-}

m.



 drivers/usb/misc/usbled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/usbled.c b/drivers/usb/misc/usbled.c
index 1732d9b..1616ad1 100644
--- a/drivers/usb/misc/usbled.c
+++ b/drivers/usb/misc/usbled.c
@@ -45,7 +45,7 @@ struct usb_led {
 
 static void change_color(struct usb_led *led)
 {
-	int retval;
+	int retval = 0;
 	unsigned char *buffer;
 
 	buffer = kmalloc(8, GFP_KERNEL);
