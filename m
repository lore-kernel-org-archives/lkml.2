Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1DLLTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:19:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21414 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1DLLTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:19:42 -0400
X-IronPort-AV: E=Sophos;i="4.64,195,1301889600"; 
   d="scan'208";a="144559611"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, konrad.wilk@oracle.com, jeremy@goop.org,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        hpa@linux.intel.com, mingo@elte.hu,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/4] xen: more debugging in the e820 parsing
Date: Tue, 12 Apr 2011 12:19:51 +0100
Message-Id: <1302607192-21355-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
X-OriginalArrivalTime: 12 Apr 2011 11:19:41.0863 (UTC) FILETIME=[84CFF370:01CBF903]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/setup.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index fa0269a..9c38bd1 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -61,6 +61,8 @@ static __init void xen_add_extra_mem(unsigned long pages)
 		return;
 
 	e820_add_region(extra_start, size, E820_RAM);
+	printk(KERN_DEBUG "extra e820 region: start=%016Lx end=%016Lx\n",
+			extra_start, extra_start + size);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
 	memblock_x86_reserve_range(extra_start, extra_start + size, "XEN EXTRA");
@@ -231,6 +233,8 @@ char * __init xen_memory_setup(void)
 	for (i = 0; i < memmap.nr_entries; i++) {
 		unsigned long long end;
 
+		printk(KERN_DEBUG "e820_region: type=%d start=%016Lx end=%016Lx",
+				map[i].type, map[i].addr, map[i].size + map[i].addr);
 		/* Guard against non-page aligned E820 entries. */
 		if (map[i].type == E820_RAM)
 			map[i].size -= (map[i].size + map[i].addr) % PAGE_SIZE;
-- 
1.7.2.3

