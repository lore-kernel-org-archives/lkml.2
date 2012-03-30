Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675Ab2C3MSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:18:41 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48615 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab2C3MSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:22 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 42/76] ACPI: ec: Do request_region outside WARN()
Date: Fri, 30 Mar 2012 06:13:45 -0400
Message-id: <d6795fe32da13bde39ea483e42799a22daa730b5.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

WARN() is not supposed to have side effects, so move the request_regions
outside.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/ec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index b19a18d..3268dcf 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -812,10 +812,10 @@ static int acpi_ec_add(struct acpi_device *device)
 		first_ec = ec;
 	device->driver_data = ec;
 
-	WARN(!request_region(ec->data_addr, 1, "EC data"),
-	     "Could not request EC data io port 0x%lx", ec->data_addr);
-	WARN(!request_region(ec->command_addr, 1, "EC cmd"),
-	     "Could not request EC cmd io port 0x%lx", ec->command_addr);
+	ret = !!request_region(ec->data_addr, 1, "EC data");
+	WARN(!ret, "Could not request EC data io port 0x%lx", ec->data_addr);
+	ret = !!request_region(ec->command_addr, 1, "EC cmd");
+	WARN(!ret, "Could not request EC cmd io port 0x%lx", ec->command_addr);
 
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
-- 
1.7.10.rc2.19.gfae9d

