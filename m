Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1DLLTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:19:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21414 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1DLLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:19:44 -0400
X-IronPort-AV: E=Sophos;i="4.64,195,1301889600"; 
   d="scan'208";a="144559613"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, konrad.wilk@oracle.com, jeremy@goop.org,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        hpa@linux.intel.com, mingo@elte.hu,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 4/4] xen: do not create the extra e820 region at an addr lower than 4G
Date: Tue, 12 Apr 2011 12:19:52 +0100
Message-Id: <1302607192-21355-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
X-OriginalArrivalTime: 12 Apr 2011 11:19:43.0832 (UTC) FILETIME=[85FC6580:01CBF903]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Do not add the extra e820 region at a physical address lower than 4G
because it breaks e820_end_of_low_ram_pfn().

It is OK for us to move the xen_extra_mem_start up and down because this
is the index of the memory that can be ballooned in/out - it is memory
not available to the kernel during bootup.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 9c38bd1..a51e010 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -229,7 +229,7 @@ char * __init xen_memory_setup(void)
 
 	memcpy(map_raw, map, sizeof(map));
 	e820.nr_map = 0;
-	xen_extra_mem_start = mem_end;
+	xen_extra_mem_start = max((1ULL << 32), mem_end);
 	for (i = 0; i < memmap.nr_entries; i++) {
 		unsigned long long end;
 
-- 
1.7.2.3

