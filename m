Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab2GLWYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:24:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33007 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2GLWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:23:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: [ 002/187] ARM: tegra: make tegra_cpu_reset_handler_enable() __init
Date: Thu, 12 Jul 2012 15:23:30 -0700
Message-Id: <20120712191522.457726552@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.378465973@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.378465973@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 6355f25ed965421725d92cf719fc63008690ca1c upstream.

This solves a section mismatch warning. I hadn't noticed this before,
because my compiler was inlining tegra_cpu_reset_handler_enable() inside
tegra_cpu_reset_handler_init(), which is already __init, but I switched
compilers and it stopped doing that.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/reset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -33,7 +33,7 @@
 
 static bool is_enabled;
 
-static void tegra_cpu_reset_handler_enable(void)
+static void __init tegra_cpu_reset_handler_enable(void)
 {
 	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
 	void __iomem *evp_cpu_reset =


