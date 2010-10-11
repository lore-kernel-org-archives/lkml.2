Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0JKXdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:33:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59063 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0JKXdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:33:20 -0400
Date: Tue, 12 Oct 2010 10:33:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?B?IkVyaWMgQsOpbmFyZCI=?= <eric@eukrea.com>
Subject: linux-next: manual merge of the arm tree with the arm-current tree
Message-Id: <20101012103314.41b00cbe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-imx/mach-cpuimx27.c between commit
4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
selection") from the arm-current tree and commit
77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
to add imx-i2c devices") from the arm tree.

I fixed it up (see below) can can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-cpuimx27.c
index 6830afd,28f73a1..0000000
--- a/arch/arm/mach-imx/mach-cpuimx27.c
+++ b/arch/arm/mach-imx/mach-cpuimx27.c
@@@ -259,8 -258,9 +258,9 @@@ static void __init eukrea_cpuimx27_init
  	i2c_register_board_info(0, eukrea_cpuimx27_i2c_devices,
  				ARRAY_SIZE(eukrea_cpuimx27_i2c_devices));
  
- 	imx27_add_i2c_imx0(&cpuimx27_i2c1_data);
 -	imx27_add_imx_i2c(1, &cpuimx27_i2c1_data);
++	imx27_add_imx_i2c(0, &cpuimx27_i2c1_data);
  
+ 	imx27_add_fec(NULL);
  	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
  
  #if defined(CONFIG_MACH_EUKREA_CPUIMX27_USESDHC2)
