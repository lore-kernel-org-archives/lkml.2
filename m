Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115Ab2JCTHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:07:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2JCTHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:07:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH] ARM: mv78xx0: correct addr_map_cfg __initdata annotation
Date: Wed, 3 Oct 2012 19:06:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210031906.35123.arnd@arndb.de>
X-Provags-ID: V02:K0:fDTer3LnzWYjre++m8jL0desTL3t/7KqVPwvMV0uW7B
 b7Gaw7+GA+Eurh7bjWcKJW1BmvR38CElxROnCqwEHJ3+1A+MMv
 yINqrQ+3rOGhZVLdF4GSKpOVqL25b6ZL4LZmVWlRp0btLf66Cl
 yTiNBhVR201tlO/2cmAL9u0kwA2XN33HT5b15LOLBw1AXluU05
 bdSrWzxBCyRD3ieVX62/4zJcNqlmU9yy4sBeoFIU8AeQU4Bfp3
 vliP+bTj3K5HNtiy+igF43sjt7Cg3qeRtsATrIW4CUEk+1Aj81
 byRDi1pLyf6Fg4mJzlSHt//cW+pzW1KHfFo4aeTgaaLAtjfIGu
 I89EQEc3JEYy8BNn37Ys=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The annotation on the addr_map_cfg variable is in the wrong place.

Without this patch, building mv78xx0_defconfig results in:

/home/arnd/linux-arm/arch/arm/mach-mv78xx0/addr-map.c:59:2: warning: initialization from incompatible pointer type [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-mv78xx0/addr-map.c:59:2: warning: (near initialization for 'addr_map_cfg.win_cfg_base') [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
---
Queued in the late/fixes branch

diff --git a/arch/arm/mach-mv78xx0/addr-map.c b/arch/arm/mach-mv78xx0/addr-map.c
index a9bc841..03f7486 100644
--- a/arch/arm/mach-mv78xx0/addr-map.c
+++ b/arch/arm/mach-mv78xx0/addr-map.c
@@ -53,7 +53,7 @@ static void __init __iomem *win_cfg_base(const struct orion_addr_map_cfg *cfg, i
 /*
  * Description of the windows needed by the platform code
  */
-static struct __initdata orion_addr_map_cfg addr_map_cfg = {
+static struct orion_addr_map_cfg addr_map_cfg __initdata = {
 	.num_wins = 14,
 	.remappable_wins = 8,
 	.win_cfg_base = win_cfg_base,
