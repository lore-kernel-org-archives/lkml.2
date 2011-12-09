Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1LIRIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:08:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49439 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1LIRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:07:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH RESEND 8/8] serial: 8250: fix comment about accessing EMSR
Date: Fri,  9 Dec 2011 18:07:20 +0100
Message-Id: <1323450440-414-9-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All docs I checked do say LCR should NOT be 0xBF (16c850, 16c854,
16v2750). Fix it according to that, since the only usage of the register
currently implements the revised access method. If somebody later finds
a derivate which actually does need 0xBF to enable that register, we can
update the comment again with precise references.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 include/linux/serial_reg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 0267bab6..0a1beca 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -211,7 +211,7 @@
 #define UART_FCTR_TX		0x80  /* Programmable trigger mode select */
 
 /*
- * LCR=0xBF, FCTR[6]=1
+ * LCR!=0xBF (some docs say =0), FCTR[6]=1, XR16C85x
  */
 #define UART_EMSR	7	/* Extended Mode Select Register */
 #define UART_EMSR_FIFO_COUNT	0x01  /* Rx/Tx select */
-- 
1.7.7.3

