Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2EARbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:31:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32792 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2EARas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:30:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] Export acpi_processor_set_pdc to modules.
Date: Tue,  1 May 2012 13:24:53 -0400
Message-Id: <1335893094-6904-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen ACPI module calls acpi_processor_set_pdc for ACPI IDs
for CPUs that are not visible to an instance of a running Linux
kernel. Meaning it calls them on the ones that the generic
code has no control over. But without this being exported
the module will fail to compile.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/acpi/processor_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index c850de4..7c7c2d9 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -352,6 +352,7 @@ void __cpuinit acpi_processor_set_pdc(acpi_handle handle)
 	kfree(obj_list->pointer);
 	kfree(obj_list);
 }
+EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
 
 static acpi_status __init
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
-- 
1.7.7.5

