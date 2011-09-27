Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1I0Rbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:31:37 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46238 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751856Ab1I0Rbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:31:36 -0400
Message-ID: <4E820876.5090206@xenotime.net>
Date: Tue, 27 Sep 2011 10:31:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] dmar: fix build warnings when ACPI is not enabled
References: <20110926172348.be01ff9a1c16267ffd000d2a@canb.auug.org.au>
In-Reply-To: <20110926172348.be01ff9a1c16267ffd000d2a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build warnings when CONFIG_ACPI is not enabled:

include/linux/dmar.h:248:46: warning: 'struct acpi_dmar_header' declared inside parameter list
include/linux/dmar.h:248:46: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/dmar.h:252:46: warning: 'struct acpi_dmar_header' declared inside parameter list

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/dmar.h |    2 ++
 1 file changed, 2 insertions(+)

--- next-2011-0927.orig/include/linux/dmar.h
+++ next-2011-0927/include/linux/dmar.h
@@ -244,6 +244,8 @@ extern int dmar_parse_dev_scope(void *st
 				struct pci_dev ***devices, u16 segment);
 extern int intel_iommu_init(void);
 #else /* !CONFIG_INTEL_IOMMU: */
+struct acpi_dmar_header;
+
 static inline int intel_iommu_init(void) { return -ENODEV; }
 static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 {
