Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2JNOnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46634 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256Ab2JNOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:43 -0400
Message-Id: <20121014143541.581864643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lin Ming <ming.m.lin@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 057/147] ACPI: run _OSC after ACPI_FULL_INITIALIZATION
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit fc54ab72959edbf229b65ac74b2f122d799ca002 upstream.

The _OSC method may exist in module level code,
so it must be called after ACPI_FULL_INITIALIZATION

On some new platforms with Zero-Power-Optical-Disk-Drive (ZPODD)
support, this fix is necessary to save power.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/bus.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index e059695..d59175e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -994,8 +994,6 @@ static int __init acpi_bus_init(void)
 	status = acpi_ec_ecdt_probe();
 	/* Ignore result. Not having an ECDT is not fatal. */
 
-	acpi_bus_osc_support();
-
 	status = acpi_initialize_objects(ACPI_FULL_INITIALIZATION);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX "Unable to initialize ACPI objects\n");
@@ -1003,6 +1001,12 @@ static int __init acpi_bus_init(void)
 	}
 
 	/*
+	 * _OSC method may exist in module level code,
+	 * so it must be run after ACPI_FULL_INITIALIZATION
+	 */
+	acpi_bus_osc_support();
+
+	/*
 	 * _PDC control method may load dynamic SSDT tables,
 	 * and we need to install the table handler before that.
 	 */


