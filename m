Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0FSNcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 09:32:32 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:54232 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0FSNcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 09:32:31 -0400
Message-ID: <4C1CC6E9.6000701@mandriva.org>
Date: Sat, 19 Jun 2010 16:32:25 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100614 Mandriva/3.0.4-11mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, mingo@redhat.com
Subject: [PATCH] x86: Fix rebooting on Dell Precision WorkStation T7400
Content-Type: multipart/mixed;
 boundary="------------050006030407080907050200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050006030407080907050200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------050006030407080907050200
Content-Type: text/x-patch;
 name="x86-kernel-set_bios_reboot-is-needed-for-Dell-Precision-WorkStation-T7400.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="x86-kernel-set_bios_reboot-is-needed-for-Dell-Precision-Work";
 filename*1="Station-T7400.patch"


Dell Precision WorkStation T7400 freezes on reboot unless reboot=b is used.

Reference: https://qa.mandriva.com/show_bug.cgi?id=58017

Signed-off-by: Thomas Backlund <tmb@mandriva.org>

--- linux-2.6/arch/x86/kernel/reboot.c.orig	2010-05-27 12:39:46.633765379 +0300
+++ linux-2.6/arch/x86/kernel/reboot.c	2010-06-19 15:56:17.250903899 +0300
@@ -228,6 +228,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell T7400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T7400",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
+		},
+	},
 	{	/* Handle problems with rebooting on HP laptops */
 		.callback = set_bios_reboot,
 		.ident = "HP Compaq Laptop",

--------------050006030407080907050200--
