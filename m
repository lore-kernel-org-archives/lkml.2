Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab2DKXlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:41:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965293Ab2DKXXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:22 -0400
Message-Id: <20120411231042.113915265@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "olof@lixom.net, Stephen Warren" <swarren@nvidia.com>
Subject: [ 39/59] [PATCH] ARM: tegra: remove Tegra30 errata from MACH_TEGRA_DT
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

[no upstream commit match, as this is a fix for a mis-applied patch in the
previous 3.2-stable release. - gregkh]

Commit 83e4194 "ARM: tegra: select required CPU and L2 errata options"
contained two chunks; one was errata for Tegra20 (correctly applied)
and the second errata for Tegra30. The latter was accidentally applied
to the wrong config option; Tegra30 support wasn't added until v3.3,
and so the second chunk should have just been dropped. This patch does
so.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-tegra/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -61,11 +61,6 @@ config MACH_SEABOARD
 config MACH_TEGRA_DT
 	bool "Generic Tegra board (FDT support)"
 	select USE_OF
-	select ARM_ERRATA_743622
-	select ARM_ERRATA_751472
-	select ARM_ERRATA_754322
-	select ARM_ERRATA_764369
-	select PL310_ERRATA_769419 if CACHE_L2X0
 	help
 	  Support for generic nVidia Tegra boards using Flattened Device Tree
 


