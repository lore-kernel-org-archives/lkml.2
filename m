Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1EDJeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:34:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43469 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1EDJeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:34:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] parport: Use request_muxed_region for IT87 probe and lock
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 04 May 2011 10:18:42 +0100
Message-ID: <20110504091828.7617.27830.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is needed as part of making the various IT87 drivers actually co-exist
politely with each other, and with other superio devices that may be muxed
on 0x2E/0x2F.

It can be applied before or after the other patches by Nat Gurumoorthy without
problem.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/parport/parport_pc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index bc8ce48..f330338 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1621,7 +1621,7 @@ static void __devinit detect_and_report_it87(void)
 	u8 origval, r;
 	if (verbose_probing)
 		printk(KERN_DEBUG "IT8705 Super-IO detection, now testing port 2E ...\n");
-	if (!request_region(0x2e, 2, __func__))
+	if (!request_muxed_region(0x2e, 2, __func__))
 		return;
 	origval = inb(0x2e);		/* Save original value */
 	outb(0x87, 0x2e);

