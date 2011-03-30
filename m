Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab1C3WNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:13:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:16640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093Ab1C3VFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132696"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: r.schtz@t-online.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [16/275] USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure
Message-Id: <20110330210410.874713E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>

commit 7e1e7bd9dbd469267b6e6de1bf8d71a7d65ce86a upstream.

The TrekStor DataStation maxi g.u external hard drive enclosure uses a
JMicron USB to SATA chip which needs the US_FL_IGNORE_RESIDUE flag to work
properly.

Signed-off-by: Richard SchÃ¼tz <r.schtz@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.35.y/drivers/usb/storage/unusual_devs.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/storage/unusual_devs.h	2011-03-29 22:52:01.660145439 -0700
+++ linux-2.6.35.y/drivers/usb/storage/unusual_devs.h	2011-03-29 23:55:32.897625408 -0700
@@ -1866,6 +1866,15 @@
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
