Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1BPBWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:22:39 -0500
Received: from kroah.org ([198.145.64.141]:45181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab1BPAri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:00 2011
Message-Id: <20110216002100.689994541@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>
Subject: [patch 016/176] USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1866,6 +1866,15 @@ UNUSUAL_DEV( 0x1908, 0x1320, 0x0000, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BAD_SENSE ),
 
+/* Patch by Richard Schütz <r.schtz@t-online.de>
+ * This external hard drive enclosure uses a JMicron chip which
+ * needs the US_FL_IGNORE_RESIDUE flag to work properly. */
+UNUSUAL_DEV(  0x1e68, 0x001b, 0x0000, 0x0000,
+		"TrekStor GmbH & Co. KG",
+		"DataStation maxi g.u",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",


