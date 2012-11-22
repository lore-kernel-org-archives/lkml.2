Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2KVVJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:09:12 -0500
Received: from shmail0.sohard.de ([212.114.139.117]:36399 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2KVSsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:48:45 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 13:48:45 EST
Date: Thu, 22 Nov 2012 19:10:50 +0100 (CET)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, mroos@linux.ee
Subject: [PATCH] ezusb: add dependency to USB
Message-ID: <f90b1aa6-492d-4431-9334-cfcfa4a92b9a@shmail0>
In-Reply-To: <6ea638d3-6ab4-42af-aadb-398cc8593f08@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.7.69.241]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an error during modpost, when ezusb is built into the kernel while USB is built as module.

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
--
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index a8f0523..fecde69 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -246,6 +246,7 @@ config USB_YUREX
 
 config USB_EZUSB_FX2
 	tristate "Functions for loading firmware on EZUSB chips"
+	depends on USB
 	help
 	  Say Y here if you need EZUSB device support.
 	  (Cypress FX/FX2/FX2LP microcontrollers)
