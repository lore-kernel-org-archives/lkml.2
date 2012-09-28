Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032001Ab2I1U6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:58:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37259 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422960Ab2I1UsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:02 -0400
X-Sasl-enc: +NCSM+PmxgcX8GeOZYWCAqx7y/PoLPcSs/XDJP1U2LKz 1348865281
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Florian=20W=C3=B6hrl?= <fw@woehrl.biz>,
        Xiaofan Chen <xiaofanc@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: =?UTF-8?q?=5B=20075/127=5D=20USB=3A=20ftdi=5Fsio=3A=20do=20not=20claim=20CDC=20ACM=20function?=
Date: Fri, 28 Sep 2012 13:34:08 -0700
Message-Id: <20120928203054.657960488@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit f08dea734844aa42ec57c229b0b73b3d7d21f810 upstream.

The Microchip vid:pid 04d8:000a is used for their CDC ACM
demo firmware application.  This is a device with a single
function conforming to the CDC ACM specification and with
the intention of demonstrating CDC ACM class firmware and
driver interaction.  The demo is used on a number of
development boards, and may also be used unmodified by
vendors using Microchip hardware.

Some vendors have re-used this vid:pid for other types of
firmware, emulating FTDI chips. Attempting to continue to
support such devices without breaking class based
applications that by matching on interface
class/subclass/proto being ff/ff/00.  I have no information
about the actual device or interface descriptors, but this
will at least make the proper CDC ACM devices work again.
Anyone having details of the offending device's descriptors
should update this entry with the details.

Reported-by: Florian Wöhrl <fw@woehrl.biz>
Reported-by: Xiaofan Chen <xiaofanc@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    4 +++-
 drivers/usb/serial/ftdi_sio_ids.h |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -803,7 +803,9 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(MICROCHIP_VID, MICROCHIP_USB_BOARD_PID) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MICROCHIP_VID, MICROCHIP_USB_BOARD_PID,
+					USB_CLASS_VENDOR_SPEC,
+					USB_SUBCLASS_VENDOR_SPEC, 0x00) },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -542,7 +542,10 @@
 /*
  * Microchip Technology, Inc.
  *
- * MICROCHIP_VID (0x04D8) and MICROCHIP_USB_BOARD_PID (0x000A) are also used by:
+ * MICROCHIP_VID (0x04D8) and MICROCHIP_USB_BOARD_PID (0x000A) are
+ * used by single function CDC ACM class based firmware demo
+ * applications.  The VID/PID has also been used in firmware
+ * emulating FTDI serial chips by:
  * Hornby Elite - Digital Command Control Console
  * http://www.hornby.com/hornby-dcc/controllers/
  */


