Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1K3RV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:21:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43215 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1K3RVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:21:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/8] ACPI: processor: cache acpi_power_register in cx structure
Date: Wed, 30 Nov 2011 12:20:58 -0500
Message-Id: <1322673664-14642-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4ED66623.0063,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

This patch save acpi_power_register in cx structure because we need
pass this to the Xen ACPI processor driver.

Signed-off-by: Yu Ke <ke.yu@intel.com>
Signed-off-by: Tian Kevin <kevin.tian@intel.com>
Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/acpi/processor_idle.c |    2 +-
 include/acpi/processor.h      |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e8e2de..d88974a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -418,7 +418,7 @@ static int acpi_processor_get_power_info_cst(struct acpi_processor *pr)
 		if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_IO &&
 		    (reg->space_id != ACPI_ADR_SPACE_FIXED_HARDWARE))
 			continue;
-
+		memcpy(&(cx.reg), reg, sizeof(*reg));
 		/* There should be an easy way to extract an integer... */
 		obj = &(element->package.elements[1]);
 		if (obj->type != ACPI_TYPE_INTEGER)
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 12657bb..bd99fb6 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -65,6 +65,7 @@ struct acpi_processor_cx {
 	u64 time;
 	u8 bm_sts_skip;
 	char desc[ACPI_CX_DESC_LEN];
+	struct acpi_power_register reg;
 };
 
 struct acpi_processor_power {
-- 
1.7.7.3

