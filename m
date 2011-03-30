Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab1C3WM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:12:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:35899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab1C3VGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447091"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: bjorn@mork.no, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [24/275] USB: io_edgeport: fix the reported firmware major and minor
Message-Id: <20110330210418.EC1DD3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Bjørn Mork <bjorn@mork.no>

commit 271c1150b4f8e1685e5a8cbf76e329ec894481da upstream.

The major and minor number saved in the product_info structure
were copied from the address instead of the data, causing an
inconsistency in the reported versions during firmware loading:

 usb 4-1: firmware: requesting edgeport/down.fw
 /usr/src/linux/drivers/usb/serial/io_edgeport.c: downloading firmware version (930) 1.16.4
 [..]
 /usr/src/linux/drivers/usb/serial/io_edgeport.c: edge_startup - time 3 4328191260
 /usr/src/linux/drivers/usb/serial/io_edgeport.c:   FirmwareMajorVersion  0.0.4

This can cause some confusion whether firmware loaded successfully
or not.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/io_edgeport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/serial/io_edgeport.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/io_edgeport.c	2011-03-29 22:51:58.665222072 -0700
+++ linux-2.6.35.y/drivers/usb/serial/io_edgeport.c	2011-03-29 23:02:58.709333195 -0700
@@ -2894,8 +2894,8 @@
 
 	dbg("%s %d.%d.%d", fw_info, rec->data[0], rec->data[1], build);
 
-	edge_serial->product_info.FirmwareMajorVersion = fw->data[0];
-	edge_serial->product_info.FirmwareMinorVersion = fw->data[1];
+	edge_serial->product_info.FirmwareMajorVersion = rec->data[0];
+	edge_serial->product_info.FirmwareMinorVersion = rec->data[1];
 	edge_serial->product_info.FirmwareBuildNumber = cpu_to_le16(build);
 
 	for (rec = ihex_next_binrec(rec); rec;
