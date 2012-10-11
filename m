Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2JKCLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:11:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55545 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758085Ab2JKCLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:11:33 -0400
X-Sasl-enc: TR8qvB6ms1ljSlCbYSChOSdy+DNU0J8OvaCPXt89+vKa 1349921491
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lin Ming <ming.m.lin@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 04/84] ACPI: run _OSC after ACPI_FULL_INITIALIZATION
Date: Thu, 11 Oct 2012 11:02:48 +0900
Message-Id: <20121011015417.842895584@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/bus.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -944,8 +944,6 @@ static int __init acpi_bus_init(void)
 	status = acpi_ec_ecdt_probe();
 	/* Ignore result. Not having an ECDT is not fatal. */
 
-	acpi_bus_osc_support();
-
 	status = acpi_initialize_objects(ACPI_FULL_INITIALIZATION);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX "Unable to initialize ACPI objects\n");
@@ -953,6 +951,12 @@ static int __init acpi_bus_init(void)
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


