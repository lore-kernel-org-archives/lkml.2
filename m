Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab1C3VGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:18706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104Ab1C3VFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447057"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com,
        scarletpimpernal@hotmail.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [18/275] USB: usb-storage: unusual_devs entry for Coby MP3 player
Message-Id: <20110330210412.A06863E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 3ea3c9b5a8464ec8223125f95e5dddb3bfd02a39 upstream.

This patch (as1444) adds an unusual_devs entry for an MP3 player from
Coby electronics.  The device has two nasty bugs.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Jasper Mackenzie <scarletpimpernal@hotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/usb/storage/unusual_devs.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/storage/unusual_devs.h	2011-03-29 23:02:58.578336548 -0700
+++ linux-2.6.35.y/drivers/usb/storage/unusual_devs.h	2011-03-29 23:55:29.557710869 -0700
@@ -1884,6 +1884,13 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
 
+/* Reported by Jasper Mackenzie <scarletpimpernal@hotmail.com> */
+UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0000,
+		"Coby Electronics",
+		"MP3 Player",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",
