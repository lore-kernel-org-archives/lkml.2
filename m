Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2F1WUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:20:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab2F1WUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:20:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH missing 2/21] fujitsu-tablet: Use struct dev_pm_ops for power management
Date: Fri, 29 Jun 2012 00:26:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>, Robert Gerlach <khnz@gmx.de>
References: <201206232306.06602.rjw@sisk.pl>
In-Reply-To: <201206232306.06602.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206290026.11041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the fujitsu-tablet driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi all,

Another driver overlooked during the ACPI conversion to PM handling based on
struct dev_pm_ops, sorry about that.

This one should go after the classmate-laptop patch I've just posted.

Thanks,
Rafael

---
 drivers/platform/x86/fujitsu-tablet.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/drivers/platform/x86/fujitsu-tablet.c
===================================================================
--- linux.orig/drivers/platform/x86/fujitsu-tablet.c
+++ linux/drivers/platform/x86/fujitsu-tablet.c
@@ -440,12 +440,14 @@ static int __devexit acpi_fujitsu_remove
 	return 0;
 }
 
-static int acpi_fujitsu_resume(struct acpi_device *adev)
+static int acpi_fujitsu_resume(struct device *dev)
 {
 	fujitsu_reset();
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(acpi_fujitsu_pm, NULL, acpi_fujitsu_resume);
+
 static struct acpi_driver acpi_fujitsu_driver = {
 	.name  = MODULENAME,
 	.class = "hotkey",
@@ -453,8 +455,8 @@ static struct acpi_driver acpi_fujitsu_d
 	.ops   = {
 		.add    = acpi_fujitsu_add,
 		.remove	= acpi_fujitsu_remove,
-		.resume = acpi_fujitsu_resume,
-	}
+	},
+	.drv.pm = &acpi_fujitsu_pm,
 };
 
 static int __init fujitsu_module_init(void)

