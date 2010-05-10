Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab0EJX1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:27:20 -0400
Received: from kroah.org ([198.145.64.141]:33426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559Ab0EJWxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:02 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.130186726@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>, Len Brown <lenb@kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>, Len Brown <len.brown@intel.com>
Subject: [108/117] power_meter: acpi_device_class "power_meter_resource" too long
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 18262714ca0fb65c290b8ea1807b2b02bb52d0e3 upstream.

acpi_device_class can only be 19 characters and a NULL terminator.

The current code has a buffer overflow in acpi_power_meter_add():
       strcpy(acpi_device_class(device), ACPI_POWER_METER_CLASS);

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/power_meter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/power_meter.c
+++ b/drivers/acpi/power_meter.c
@@ -34,7 +34,7 @@
 #define ACPI_POWER_METER_NAME		"power_meter"
 ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
 #define ACPI_POWER_METER_DEVICE_NAME	"Power Meter"
-#define ACPI_POWER_METER_CLASS		"power_meter_resource"
+#define ACPI_POWER_METER_CLASS		"pwr_meter_resource"
 
 #define NUM_SENSORS			17
 


