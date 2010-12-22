Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0LVN3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:29:18 -0500
Received: from mailout04.t-online.de ([194.25.134.18]:56904 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0LVN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:29:17 -0500
Message-ID: <4D11FD18.6090100@t-online.de>
Date: Wed, 22 Dec 2010 14:28:56 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sergey Vlasov <vsu@altlinux.ru>, Greg KH <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [PATCH v2] USB: usb-storage: unusual_devs update for TrekStor DataStation
 maxi g.u external hard drive enclosure
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: ESav-8ZYwhT0CoJfPP5V6gtNRIHlCReZfPPOXV5GPQ6KC3XM+cyeIoAM8PHQIAOwH5
X-TOI-MSGID: ee178638-69b0-46ea-90f3-1d6a9ddc9300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TrekStor DataStation maxi g.u external hard drive enclosure uses a
JMicron USB to SATA chip which needs the US_FL_IGNORE_RESIDUE flag to work
properly.

Signed-off-by: Richard Schütz <r.schtz@t-online.de>
---

Applies to 2.6.37-rc7 now.

--- a/drivers/usb/storage/unusual_devs.h	2010-12-21 20:26:40.000000000 +0100
+++ b/drivers/usb/storage/unusual_devs.h	2010-12-22 13:37:58.438818902 +0100
@@ -1872,6 +1872,15 @@ UNUSUAL_DEV( 0x1908, 0x3335, 0x0200, 0x0
  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
  		US_FL_NO_READ_DISC_INFO ),

+/* Patch by Richard Schütz <r.schtz@t-online.de>
+ * This external hard drive enclosure uses a JMicron chip which
+ * needs the US_FL_IGNORE_RESIDUE flag to work properly. */
+UNUSUAL_DEV(  0x1e68, 0x001b, 0x0000, 0x0000,
+		"TrekStor GmbH & Co. KG",
+		"DataStation maxi g.u",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
+
  UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
  		"ST",
  		"2A",

-- 
Regards,
Richard Schütz
