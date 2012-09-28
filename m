Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946405Ab2I1Vp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:45:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032297Ab2I1UZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <bp@amd64.org>, Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 061/218] ACPI / PM: Use KERN_DEBUG when no power resources are found
Date: Fri, 28 Sep 2012 13:14:38 -0700
Message-Id: <20120928201508.555677500@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit f25b70613c048ceb1df052576fda03321ebf41cf upstream.

commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
devices which have _PRx, if a device does not have _PRx, a warning
message will be printed.

This commit is for ZPODD on Intel ZPODD capable platforms, on other
platforms, it has no problem if there is no power resource for this
device, so a warning here is not appropriate, change it to debug.

Reported-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -468,7 +468,7 @@ int acpi_power_resource_register_device(
 	return ret;
 
 no_power_resource:
-	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
+	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
 	return -ENODEV;
 }
 


