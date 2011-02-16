Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1BPCPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:15:38 -0500
Received: from kroah.org ([198.145.64.141]:38697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab1BPASk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:27 2011
Message-Id: <20110216001427.850648264@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [028/272] USB: io_edgeport: fix the reported firmware major and minor
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2889,8 +2889,8 @@ static void load_application_firmware(st
 
 	dbg("%s %d.%d.%d", fw_info, rec->data[0], rec->data[1], build);
 
-	edge_serial->product_info.FirmwareMajorVersion = fw->data[0];
-	edge_serial->product_info.FirmwareMinorVersion = fw->data[1];
+	edge_serial->product_info.FirmwareMajorVersion = rec->data[0];
+	edge_serial->product_info.FirmwareMinorVersion = rec->data[1];
 	edge_serial->product_info.FirmwareBuildNumber = cpu_to_le16(build);
 
 	for (rec = ihex_next_binrec(rec); rec;


