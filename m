Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab2L1TSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55288 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2L1TSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:24 -0500
Message-Id: <20121228190352.685272164@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 107/173] x86,AMD: Power driver support for AMDs family 16h processors
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit 22e32f4f57778ebc6e17812fa3008361c05d64f9 upstream.

Add family 16h PCI ID to AMD's power driver to allow it report
power consumption on these processors.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/fam15h_power.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -31,6 +31,9 @@ MODULE_DESCRIPTION("AMD Family 15h CPU p
 MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
 MODULE_LICENSE("GPL");
 
+/* Family 16h Northbridge's function 4 PCI ID */
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
+
 /* D18F3 */
 #define REG_NORTHBRIDGE_CAP		0xe8
 
@@ -256,6 +259,7 @@ static void __devexit fam15h_power_remov
 
 static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);


