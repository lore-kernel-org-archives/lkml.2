Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0LSVYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:24:30 -0500
Received: from mailout06.t-online.de ([194.25.134.19]:39337 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab0LSVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:24:28 -0500
Message-ID: <4D0E7803.30809@t-online.de>
Date: Sun, 19 Dec 2010 22:24:19 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergey Vlasov <vsu@altlinux.ru>, Greg KH <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [PATCH] USB: usb-storage: unusual_devs update for TrekStor DataStation
 maxi g.u external hard drive enclosure
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: VmuZLEZrwhs9MNViOpt1h7G0X6CSh3-kj-4nxxwAuQfso1CykyuzN1S8MiFCiphZJ9
X-TOI-MSGID: cf892929-f604-415a-aabb-1344ddd506d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TrekStor DataStation maxi g.u external hard drive enclosure uses a
JMicron USB to SATA chip which needs the US_FL_IGNORE_RESIDUE flag to work
properly.

Signed-off-by: Richard Schütz <r.schtz@t-online.de>

--- a/drivers/usb/storage/unusual_devs.h	2010-12-09 23:17:27.000000000 +0100
+++ b/drivers/usb/storage/unusual_devs.h	2010-12-19 22:04:33.088943468 +0100
@@ -1859,6 +1859,15 @@ UNUSUAL_DEV( 0x1908, 0x1320, 0x0000, 0x0
  		US_SC_DEVICE, US_PR_DEVICE, NULL,
  		US_FL_BAD_SENSE ),

+/* Patch by Richard Schütz <r.schtz@t-online.de>
+ * This external hard drive enclosure uses a JMicron chip which
+ * needs the US_FL_IGNORE_RESIDUE flag to work properly. */
+UNUSUAL_DEV( 0x1e68, 0x001b, 0x0000, 0x0000,
+		"TrekStor GmbH & Co. KG",
+		"DataStation maxi g.u",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
+
  UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
  		"ST",
  		"2A",

-- 
Regards,
Richard Schütz
