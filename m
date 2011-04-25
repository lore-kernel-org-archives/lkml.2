Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1DYUWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:22:46 -0400
Received: from 1wt.eu ([62.212.114.60]:33654 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab1DYUWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:22:44 -0400
Message-Id: <20110425200233.430897047@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Nick Holloway <Nick.Holloway@pyrites.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 010/173] USB: Storage: Add unusual_devs entry for VTech Kidizoom
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


