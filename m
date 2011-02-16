Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1BPCR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:17:27 -0500
Received: from kroah.org ([198.145.64.141]:38639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab1BPASW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:26 2011
Message-Id: <20110216001426.834654787@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>
Subject: [018/272] USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>

commit 7e1e7bd9dbd469267b6e6de1bf8d71a7d65ce86a upstream.

The TrekStor DataStation maxi g.u external hard drive enclosure uses a
JMicron USB to SATA chip which needs the US_FL_IGNORE_RESIDUE flag to work
properly.

Signed-off-by: Richard SchÃ¼tz <r.schtz@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
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


