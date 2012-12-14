Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab2LNW1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:27:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:38170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab2LNW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:27:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 05/22] x86,AMD: Power driver support for AMDs family 16h processors
Date: Fri, 14 Dec 2012 14:25:50 -0800
Message-Id: <20121214222250.963691146@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit 22e32f4f57778ebc6e17812fa3008361c05d64f9 upstream.

Add family 16h PCI ID to AMD's power driver to allow it report
power consumption on these processors.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


