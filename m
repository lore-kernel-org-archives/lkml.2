Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1DYVDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:03:23 -0400
Received: from 1wt.eu ([62.212.114.60]:33660 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1DYUWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:22:46 -0400
Message-Id: <20110425200233.344032143@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 008/173] USB: io_edgeport: fix the reported firmware major and minor
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/usb/serial/io_edgeport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2935,8 +2935,8 @@ static void load_application_firmware(st
 
 	dbg("%s %d.%d.%d", fw_info, rec->data[0], rec->data[1], build);
 
-	edge_serial->product_info.FirmwareMajorVersion = fw->data[0];
-	edge_serial->product_info.FirmwareMinorVersion = fw->data[1];
+	edge_serial->product_info.FirmwareMajorVersion = rec->data[0];
+	edge_serial->product_info.FirmwareMinorVersion = rec->data[1];
 	edge_serial->product_info.FirmwareBuildNumber = cpu_to_le16(build);
 
 	for (rec = ihex_next_binrec(rec); rec;


