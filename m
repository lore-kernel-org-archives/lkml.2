Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0KXXRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:17:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab0KXXRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:17:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 5/13] ACPI / PM: Introduce function for refcounting device power resources
Date: Thu, 25 Nov 2010 00:06:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl>
In-Reply-To: <201011250001.11297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011250006.55559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce function acpi_power_on_resources() that reference counts
and possibly turns on ACPI power resources for a given device and
a given power state of it.

This function will be used for reference counting device power
resources during initialization.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/internal.h |    1 +
 drivers/acpi/power.c    |    8 ++++++++
 2 files changed, 9 insertions(+)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -485,6 +485,14 @@ int acpi_power_get_inferred_state(struct
 	return 0;
 }
 
+int acpi_power_on_resources(struct acpi_device *device, int state)
+{
+	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3)
+		return -EINVAL;
+
+	return acpi_power_on_list(&device->power.states[state].resources);
+}
+
 int acpi_power_transition(struct acpi_device *device, int state)
 {
 	int result;
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -42,6 +42,7 @@ int acpi_power_init(void);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state);
+int acpi_power_on_resources(struct acpi_device *device, int state);
 int acpi_power_transition(struct acpi_device *device, int state);
 extern int acpi_power_nocheck;
 

