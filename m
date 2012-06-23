Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2FWVTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:19:10 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab2FWVSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:18:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 17/21] xo15-ebook: Use struct dev_pm_ops for power management
Date: Sat, 23 Jun 2012 23:18:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl>
In-Reply-To: <201206232306.06602.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232318.51901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the xo15-ebook driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/xo15-ebook.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/drivers/platform/x86/xo15-ebook.c
===================================================================
--- linux.orig/drivers/platform/x86/xo15-ebook.c
+++ linux/drivers/platform/x86/xo15-ebook.c
@@ -77,11 +77,13 @@ static void ebook_switch_notify(struct a
 	}
 }
 
-static int ebook_switch_resume(struct acpi_device *device)
+static int ebook_switch_resume(struct device *dev)
 {
-	return ebook_send_state(device);
+	return ebook_send_state(to_acpi_device(dev));
 }
 
+static SIMPLE_DEV_PM_OPS(ebook_switch_pm, NULL, ebook_switch_resume);
+
 static int ebook_switch_add(struct acpi_device *device)
 {
 	struct ebook_switch *button;
@@ -161,10 +163,10 @@ static struct acpi_driver xo15_ebook_dri
 	.ids = ebook_device_ids,
 	.ops = {
 		.add = ebook_switch_add,
-		.resume = ebook_switch_resume,
 		.remove = ebook_switch_remove,
 		.notify = ebook_switch_notify,
 	},
+	.drv.pm = &ebook_switch_pm,
 };
 
 static int __init xo15_ebook_init(void)

