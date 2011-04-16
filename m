Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab1DPWRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 18:17:36 -0400
Received: from pequod.mess.org ([188.220.58.213]:35768 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab1DPWRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 18:17:31 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Apr 2011 18:17:31 EDT
Date: Sat, 16 Apr 2011 23:08:42 +0100
From: Sean Young <sean@mess.org>
To: Robin Becker <robin@reportlab.com>, Nicolas Pitre <nico@fluxnic.net>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: arm: mach-kirkwood: Make the red led available on the eSATA
 SheevaPlug
Message-ID: <20110416220842.GA1518@pequod.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch:

        7780c80 arm: mach-kirkwood: add led in sheevaplug-setup.c

On a eSATA SheevaPlug, neither the red nor the green led can be controlled,
since probing fails with:

[    6.188278] leds-gpio: probe of leds-gpio failed with error -22

Signed-off-by: Sean Young <sean@mess.org>

diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index 17de0bf..92db979 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -94,6 +94,7 @@ static unsigned int sheevaplug_mpp_config[] __initdata = {
 static unsigned int sheeva_esata_mpp_config[] __initdata = {
 	MPP29_GPIO,	/* USB Power Enable */
 	MPP44_GPIO,	/* SD Write Protect */
+	MPP46_GPIO,	/* LED Red */
 	MPP47_GPIO,	/* SD Card Detect */
 	MPP49_GPIO,	/* LED Green */
 	0
