Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0FTUzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:55:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51929 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0FTUzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:55:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:54:22 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 8/8] firewire: cdev: extend fw_cdev_event_iso_interrupt
 documentation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.2f07e0f4aa6fb821@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information regarding the 2.6.32 update to the xmit variant of
fw_cdev_event_iso_interrupt.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -209,10 +209,21 @@ struct fw_cdev_event_request2 {
  * @header:	Stripped headers, if any
  *
  * This event is sent when the controller has completed an &fw_cdev_iso_packet
- * with the %FW_CDEV_ISO_INTERRUPT bit set.  In the receive case, the headers
- * stripped of all packets up until and including the interrupt packet are
- * returned in the @header field.  The amount of header data per packet is as
- * specified at iso context creation by &fw_cdev_create_iso_context.header_size.
+ * with the %FW_CDEV_ISO_INTERRUPT bit set.
+ *
+ * Isochronous transmit events:
+ *
+ * In version 1 of the ABI, &header_length is 0.  In version 3 and some
+ * implementations of version 2 of the ABI, &header_length is a multiple of 4
+ * and &header contains timestamps of all packets up until the interrupt packet.
+ * The format of the timestamps is as described below for isochronous reception.
+ *
+ * Isochronous receive events:
+ *
+ * The headers stripped of all packets up until and including the interrupt
+ * packet are returned in the @header field.  The amount of header data per
+ * packet is as specified at iso context creation by
+ * &fw_cdev_create_iso_context.header_size.
  *
  * In version 1 of this ABI, header data consisted of the 1394 isochronous
  * packet header, followed by quadlets from the packet payload if

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

