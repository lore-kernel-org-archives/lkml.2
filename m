Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab1C3VGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:54022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163Ab1C3VGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235926"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Nick.Holloway@pyrites.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [26/275] USB: Storage: Add unusual_devs entry for VTech Kidizoom
Message-Id: <20110330210421.137FA3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Nick Holloway <Nick.Holloway@pyrites.org.uk>

commit c25f6b1591b158f7ae3b9132367d0fa6d632e70e upstream.

This device suffers from the off-by-one error when reporting the capacity,
so add entry with US_FL_FIX_CAPACITY.

Signed-off-by: Nick Holloway <Nick.Holloway@pyrites.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/usb/storage/unusual_devs.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/storage/unusual_devs.h	2011-03-29 23:02:58.597336061 -0700
+++ linux-2.6.35.y/drivers/usb/storage/unusual_devs.h	2011-03-29 23:02:58.746332249 -0700
@@ -1396,6 +1396,13 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Submitted by Nick Holloway */
+UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0100,
+		"VTech",
+		"Kidizoom",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* Reported by Michael Stattmann <michael@stattmann.com> */
 UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x0000,
 		"Sony Ericsson",
