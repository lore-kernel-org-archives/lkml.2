Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2GZPHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:07:38 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45596 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2GZPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:07:37 -0400
MIME-Version: 1.0
Date: Thu, 26 Jul 2012 10:07:36 -0500
Message-ID: <CAC1Azde2u1tFtvDqsXntekBja_X6J7opOJGB5AOb==5KEEJhQA@mail.gmail.com>
Subject: [PATCH] Add MODULE_ALIAS for autoloading ipmi driver on ACPI systems
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

Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 83f85cf..afe3b95 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2246,6 +2246,8 @@ static struct pnp_driver ipmi_pnp_driver = {
 	.remove		= __devexit_p(ipmi_pnp_remove),
 	.id_table	= pnp_dev_table,
 };
+
+MODULE_DEVICE_TABLE(pnp, pnp_dev_table);
 #endif

 #ifdef CONFIG_DMI
-- 
1.7.5.4
