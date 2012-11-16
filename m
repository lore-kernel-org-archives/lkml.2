Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab2KPNot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:44:49 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:48722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2KPNoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:44:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks
Date: Fri, 16 Nov 2012 14:49:10 +0100
Message-ID: <1453537.D7nc72D9LF@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently acpi_dev_process_resource() returns AE_ABORT_METHOD
to terminate the acpi_walk_resources() it is called from if
the .preproc() routine provided by the caller of
acpi_dev_get_resources() initiating the resources walk returns
an error code.  It is better to use AE_CTRL_TERMINATE for this
purpose, however, so do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/acpi/resource.c
===================================================================
--- linux.orig/drivers/acpi/resource.c
+++ linux/drivers/acpi/resource.c
@@ -446,7 +446,7 @@ static acpi_status acpi_dev_process_reso
 		ret = c->preproc(ares, c->preproc_data);
 		if (ret < 0) {
 			c->error = ret;
-			return AE_ABORT_METHOD;
+			return AE_CTRL_TERMINATE;
 		} else if (ret > 0) {
 			return AE_OK;
 		}

