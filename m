Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2HFO4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:56:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56596 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2HFO4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:56:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="33702043"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 22/23] arm/v2m: initialize arch_timers even if v2m_timer is not present
Date: Mon, 6 Aug 2012 15:27:25 +0100
Message-ID: <1344263246-28036-22-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-vexpress/v2m.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index fde26ad..dee1451 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -637,16 +637,17 @@ static void __init v2m_dt_timer_init(void)
 	node = of_find_compatible_node(NULL, NULL, "arm,sp810");
 	v2m_sysctl_init(of_iomap(node, 0));
 
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

