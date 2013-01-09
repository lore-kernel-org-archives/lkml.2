Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab3AIUhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:41213 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab3AIUg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 19/47] ACPI / scan: Do not use dummy HID for system bus ACPI nodes
Date: Wed,  9 Jan 2013 12:35:14 -0800
Message-Id: <20130109201731.697334439@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 4f5f64cf0cc916220aaa055992e31195470cfe37 upstream.

At one point acpi_device_set_id() checks if acpi_device_hid(device)
returns NULL, but that never happens, so system bus devices with an
empty list of PNP IDs are given the dummy HID ("device") instead of
the "system bus HID" ("LNXSYBUS").  Fix the code to use the right
check.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1153,7 +1153,7 @@ static void acpi_device_set_id(struct ac
 			acpi_add_id(device, ACPI_DOCK_HID);
 		else if (!acpi_ibm_smbus_match(device))
 			acpi_add_id(device, ACPI_SMBUS_IBM_HID);
-		else if (!acpi_device_hid(device) &&
+		else if (list_empty(&device->pnp.ids) &&
 			 ACPI_IS_ROOT_DEVICE(device->parent)) {
 			acpi_add_id(device, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
 			strcpy(device->pnp.device_name, ACPI_BUS_DEVICE_NAME);


