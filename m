Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1BKOjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:39:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53394 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab1BKOjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:39:18 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 12/13] da850: pruss SUART platform specific additions.
Date: Fri, 11 Feb 2011 20:21:31 +0530
Message-Id: <1297435892-28278-13-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the McASP clock alias.
The alias is used by the pruss suart driver
for enabling the McASP PSC.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/devices-da8xx.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index e15de72..f1cf605 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -560,7 +560,18 @@ struct platform_device da8xx_pruss_dev = {
 
 int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
 {
+#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
+	int ret;
+#endif
+
 	da8xx_pruss_dev.dev.platform_data = pruss_device;
+
+#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
+	ret = clk_add_alias(NULL, "da8xx_pruss_uart.1",
+	NULL, &da850_mcasp_device.dev);
+	if (ret < 0)
+		return ret;
+#endif
 	return platform_device_register(&da8xx_pruss_dev);
 }
 
-- 
1.7.2.3

