Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab0IRT2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:28:12 -0400
Received: from kroah.org ([198.145.64.141]:43566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab0IRTPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:31 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.264858210@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Ott <alan@signal11.us>, Jiri Kosina <jkosina@suse.cz>
Subject: [069/129] HID: Set Report ID properly for Output reports on the Control endpoint.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Ott <alan@signal11.us>

commit c29771c2d8ceb907ed45eb8c7fc0450308140aca upstream.

When I made commit 29129a98e6fc89 ("HID: Send Report ID when numbered
reports are sent over the control endpoint"), I didn't account for *buf
not being the report ID anymore, as buf is incremented.

Signed-off-by: Alan Ott <alan@signal11.us>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -828,6 +828,7 @@ static int usbhid_output_raw_report(stru
 		}
 	} else {
 		int skipped_report_id = 0;
+		int report_id = buf[0];
 		if (buf[0] == 0x0) {
 			/* Don't send the Report ID */
 			buf++;
@@ -837,7 +838,7 @@ static int usbhid_output_raw_report(stru
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			HID_REQ_SET_REPORT,
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			((report_type + 1) << 8) | *buf,
+			((report_type + 1) << 8) | report_id,
 			interface->desc.bInterfaceNumber, buf, count,
 			USB_CTRL_SET_TIMEOUT);
 		/* count also the report id, if this was a numbered report. */


