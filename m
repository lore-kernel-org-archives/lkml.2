Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1EFBDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:03:50 -0400
Received: from kroah.org ([198.145.64.141]:36561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab1EFAYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002206.330939018@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Haberland <stefan.haberland@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Stephen Powell <zlinuxman@wowway.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Bastian Blank <waldi@debian.org>
Subject: [013/143] [S390] dasd: correct device table
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Haberland <stefan.haberland@de.ibm.com>

commit 5da24b7627ff821e154a3aaecd5d60e1d8e228a5 upstream.

The 3880 storage control unit supports a 3380 device
type, but not a 3390 device type.

Reported-by: Stephen Powell <zlinuxman@wowway.com>
Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Stephen Powell <zlinuxman@wowway.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Bastian Blank <waldi@debian.org>

---
 drivers/s390/block/dasd_eckd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -63,7 +63,7 @@ static struct dasd_discipline dasd_eckd_
 static struct ccw_device_id dasd_eckd_ids[] = {
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3390, 0), .driver_info = 0x1},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3390, 0), .driver_info = 0x2},
-	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3390, 0), .driver_info = 0x3},
+	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3380, 0), .driver_info = 0x3},
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3380, 0), .driver_info = 0x4},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3380, 0), .driver_info = 0x5},
 	{ CCW_DEVICE_DEVTYPE (0x9343, 0, 0x9345, 0), .driver_info = 0x6},


