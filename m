Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2GZOuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:50:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55226 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2GZOun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:50:43 -0400
MIME-Version: 1.0
Date: Thu, 26 Jul 2012 09:50:40 -0500
Message-ID: <CAC1Azdenr8rXqw=Vfq4Jfoj8qDN1HmDoDehYC5Ec_3-8cvSKJQ@mail.gmail.com>
Subject: Add MODULE_ALIAS to autoload ipmi drivers on ACPI systems
From: jordan hargrave <jharg93@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest versions of the kernel drivers for ipmi can use ACPI to
determine the type of BMC device used in the system.  The following
patch adds a module alias so that udev will autoload the ipmi_si
driver.

--- drivers/char/ipmi/ipmi_si_intf.c.orig	2012-07-26 09:18:58.000000000 -0500
+++ drivers/char/ipmi/ipmi_si_intf.c	2012-07-26 09:29:37.000000000 -0500
@@ -2267,6 +2267,8 @@ static struct pnp_driver ipmi_pnp_driver
 	.remove		= __devexit_p(ipmi_pnp_remove),
 	.id_table	= pnp_dev_table,
 };
+
+MODULE_DEVICE_TABLE(pnp, pnp_dev_table);
 #endif

 #ifdef CONFIG_DMI
