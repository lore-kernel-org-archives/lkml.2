Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1BPBtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:49:31 -0500
Received: from kroah.org ([198.145.64.141]:48763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab1BPBtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:56 2011
Message-Id: <20110216014656.295767333@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nick Holloway <Nick.Holloway@pyrites.org.uk>
Subject: [020/115] USB: Storage: Add unusual_devs entry for VTech Kidizoom
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Holloway <Nick.Holloway@pyrites.org.uk>

commit c25f6b1591b158f7ae3b9132367d0fa6d632e70e upstream.

This device suffers from the off-by-one error when reporting the capacity,
so add entry with US_FL_FIX_CAPACITY.

Signed-off-by: Nick Holloway <Nick.Holloway@pyrites.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1410,6 +1410,13 @@ UNUSUAL_DEV(  0x0fca, 0x0006, 0x0001, 0x
 		US_FL_IGNORE_DEVICE ),
 #endif
 
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


