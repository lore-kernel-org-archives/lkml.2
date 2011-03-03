Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1CCAwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:52:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58037 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1CCAwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:52:15 -0500
Date: Thu, 3 Mar 2011 11:52:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Xuetao Guan <epip.guan@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        GuanXuetao <gxt@mprc.pku.edu.cn>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the unicore32 tree with the i.MX tree
Message-Id: <20110303115210.b0e8786b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xuetao,

Today's linux-next merge of the unicore32 tree got a conflict in
drivers/video/Kconfig between commit
657df5cdfd525648a04b3db69eaa1ba8eb1baf87 ("video: Add i.MX23/28
framebuffer driver") from the i.MX tree and commit
a336d8ba89b5afe129cb9178f26216b22d6beb63 ("unicore32 machine related: add
frame buffer driver for pkunity-v3 soc") from the unicore32 tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/Kconfig
index 8a2f8cf,ec55a87..0000000
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@@ -2320,15 -2365,17 +2320,26 @@@ config FB_JZ474
  	help
  	  Framebuffer support for the JZ4740 SoC.
  
 +config FB_MXS
 +	tristate "MXS LCD framebuffer support"
 +	depends on FB && ARCH_MXS
 +	select FB_CFB_FILLRECT
 +	select FB_CFB_COPYAREA
 +	select FB_CFB_IMAGEBLIT
 +	help
 +	  Framebuffer support for the MXS SoC.
 +
+ config FB_PUV3_UNIGFX
+ 	tristate "PKUnity v3 Unigfx framebuffer support"
+ 	depends on FB && UNICORE32 && ARCH_PUV3
+ 	select FB_SYS_FILLRECT
+ 	select FB_SYS_COPYAREA
+ 	select FB_SYS_IMAGEBLIT
+ 	select FB_SYS_FOPS
+ 	help
+ 	  Choose this option if you want to use the Unigfx device as a
+ 	  framebuffer device. Without the support of PCI & AGP.
+ 
  source "drivers/video/omap/Kconfig"
  source "drivers/video/omap2/Kconfig"
  
