Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1BERrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:23 -0500
Received: from tur.go2.pl ([193.17.41.50]:50210 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1BERrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:20 -0500
Message-ID: <4D4D8CEC.4090500@o2.pl>
Date: Sat, 05 Feb 2011 18:46:20 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Paul Mortier <mortier@btinternet.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [USB]Add quirk for Samsung Android phone modem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 69
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[USB]Add quirk for Samsung Android phone modem

My Galaxy Spica needs this quirk when in modem mode, otherwise
it causes endless USB bus resets and is unusable in this mode.

Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
for the modem part.
That's why in addition to this patch the visior driver must be prevented
from binding to SPH-I500 ID, so ACM driver can do that.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 44c5954..363355b 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -88,6 +88,10 @@ static const struct usb_device_id usb_quirk_list[] = {
     /* INTEL VALUE SSD */
     { USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+    /* Samsung Android phone modem - ID conflict with SPH-I500 */
+    { USB_DEVICE(0x04e8, 0x6601), .driver_info =
+            USB_QUIRK_CONFIG_INTF_STRINGS },
+
     { }  /* terminating entry must be last */
 };
 

