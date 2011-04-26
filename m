Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab1DZVSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:18:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:60664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab1DZVPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748959"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: stefan.haberland@de.ibm.com, schwidefsky@de.ibm.com, ak@linux.intel.com,
        zlinuxman@wowway.com, jrnieder@gmail.com, waldi@debian.org,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [95/106] dasd: correct device table
Message-Id: <20110426211417.9E9873E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefan Haberland <stefan.haberland@de.ibm.com>

commit 5da24b7627ff821e154a3aaecd5d60e1d8e228a5 upstream.

The 3880 storage control unit supports a 3380 device
type, but not a 3390 device type.

Reported-by: Stephen Powell <zlinuxman@wowway.com>
Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Powell <zlinuxman@wowway.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Bastian Blank <waldi@debian.org>

---
 drivers/s390/block/dasd_eckd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/s390/block/dasd_eckd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/s390/block/dasd_eckd.c
+++ linux-2.6.35.y/drivers/s390/block/dasd_eckd.c
@@ -63,7 +63,7 @@ static struct dasd_discipline dasd_eckd_
 static struct ccw_device_id dasd_eckd_ids[] = {
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3390, 0), .driver_info = 0x1},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3390, 0), .driver_info = 0x2},
-	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3390, 0), .driver_info = 0x3},
+	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3380, 0), .driver_info = 0x3},
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3380, 0), .driver_info = 0x4},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3380, 0), .driver_info = 0x5},
 	{ CCW_DEVICE_DEVTYPE (0x9343, 0, 0x9345, 0), .driver_info = 0x6},
