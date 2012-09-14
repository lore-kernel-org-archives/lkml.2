Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab2INLlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:41:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57760 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422Ab2INLls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:41:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="208102978"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 21/24] arm/v2m: initialize arch_timers even if v2m_timer is not present
Date: Fri, 14 Sep 2012 12:13:23 +0100
Message-ID: <1347621207-11294-21-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-vexpress/v2m.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 37608f2..4e567f7 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -621,16 +621,17 @@ static void __init v2m_dt_timer_init(void)
 
 	v2m_clk_init();
 
-	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
-	if (WARN_ON(err))
-		return;
-	node = of_find_node_by_path(path);
-	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
 	if (arch_timer_of_register() != 0)
 		twd_local_timer_of_register();
 
 	if (arch_timer_sched_clock_init() != 0)
 		versatile_sched_clock_init(v2m_sysreg_base + V2M_SYS_24MHZ, 24000000);
+
+	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
+	if (WARN_ON(err))
+		return;
+	node = of_find_node_by_path(path);
+	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
 }
 
 static struct sys_timer v2m_dt_timer = {
-- 
1.7.2.5

