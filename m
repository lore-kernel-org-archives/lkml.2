Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab1BPAsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:48:17 -0500
Received: from kroah.org ([198.145.64.141]:45249 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab1BPAsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:01 2011
Message-Id: <20110216002101.900041982@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nick Holloway <Nick.Holloway@pyrites.org.uk>
Subject: [patch 028/176] USB: Storage: Add unusual_devs entry for VTech Kidizoom
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1396,6 +1396,13 @@ UNUSUAL_DEV(  0x0f19, 0x0105, 0x0100, 0x
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


