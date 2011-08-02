Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1HBA7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:59:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56047 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab1HBA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:59:25 -0400
Date: Tue, 2 Aug 2011 10:59:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: linux-next: manual merge of the msm tree with Linus' tree
Message-Id: <20110802105920.b17b44333263c79316a186c5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/mach-msm/io.c between commit 03db0729b760 ("msm: Remove
chip-ifdefs for GPIO io mappings") from Linus' tree and commit
5f0130d53e0e ("msm: dma: use a platform device for msm_dmov") from the
msm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/io.c
index 140ddbb,1c86cda..0000000
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@@ -42,9 -42,8 +42,8 @@@
  static struct map_desc msm_io_desc[] __initdata = {
  	MSM_DEVICE(VIC),
  	MSM_CHIP_DEVICE(CSR, MSM7X00),
- 	MSM_DEVICE(DMOV),
 -	MSM_DEVICE(GPIO1),
 -	MSM_DEVICE(GPIO2),
 +	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
 +	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
  	MSM_DEVICE(CLK_CTL),
  #ifdef CONFIG_MSM_DEBUG_UART
  	MSM_DEVICE(DEBUG_UART),
@@@ -75,9 -74,8 +74,8 @@@ void __init msm_map_common_io(void
  static struct map_desc qsd8x50_io_desc[] __initdata = {
  	MSM_DEVICE(VIC),
  	MSM_CHIP_DEVICE(CSR, QSD8X50),
- 	MSM_DEVICE(DMOV),
 -	MSM_DEVICE(GPIO1),
 -	MSM_DEVICE(GPIO2),
 +	MSM_CHIP_DEVICE(GPIO1, QSD8X50),
 +	MSM_CHIP_DEVICE(GPIO2, QSD8X50),
  	MSM_DEVICE(CLK_CTL),
  	MSM_DEVICE(SIRC),
  	MSM_DEVICE(SCPLL),
@@@ -134,9 -132,8 +132,8 @@@ void __init msm_map_msm8960_io(void
  static struct map_desc msm7x30_io_desc[] __initdata = {
  	MSM_DEVICE(VIC),
  	MSM_CHIP_DEVICE(CSR, MSM7X30),
- 	MSM_DEVICE(DMOV),
 -	MSM_DEVICE(GPIO1),
 -	MSM_DEVICE(GPIO2),
 +	MSM_CHIP_DEVICE(GPIO1, MSM7X30),
 +	MSM_CHIP_DEVICE(GPIO2, MSM7X30),
  	MSM_DEVICE(CLK_CTL),
  	MSM_DEVICE(CLK_CTL_SH2),
  	MSM_DEVICE(AD5),
