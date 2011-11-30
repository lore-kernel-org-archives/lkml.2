Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab1K3RXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:23:14 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61267 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1K3RVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:21:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/8] ACPI: processor: override the interface of register acpi processor handler for Xen vcpu
Date: Wed, 30 Nov 2011 12:21:02 -0500
Message-Id: <1322673664-14642-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4ED66623.00BE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Liang <liang.tang@oracle.com>

This patch calls the check which detectes whether to override
the interface to register ACPI processor.

Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/acpi/processor_driver.c |    2 ++
 include/acpi/processor.h        |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 55f0b89..2fec82e 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -815,6 +815,8 @@ static int __init acpi_processor_init(void)
 
 	memset(&errata, 0, sizeof(errata));
 
+	xen_processor_driver_register();
+
 	if (__acpi_processor_register_driver) {
 		result = __acpi_processor_register_driver();
 		if (result < 0)
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 969cbc9..cf53ed8 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -283,6 +283,10 @@ static inline void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx
 }
 #endif
 
+/* in processor_xen.c */
+extern void xen_processor_driver_register(void);
+
+
 /* in processor_perflib.c */
 
 #ifdef CONFIG_CPU_FREQ
-- 
1.7.7.3

