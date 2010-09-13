Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0IMByM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 21:54:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42651 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0IMByK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 21:54:10 -0400
Date: Mon, 13 Sep 2010 11:54:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Hannemann <arnd@arndnet.de>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20100913115404.cfbe7182.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/mach-shmobile/board-ap4evb.c between commit
410d878bd05315a19894b8b4685107f2cd0712a5 ("ARM: mach-shmobile: ap4evb:
fix write protect for SDHI1") from Linus' tree and commit
c3cfb4003377a3397b27de0efe910c9abd838ac3 ("ARM: mach-shmobile: ap4evb:
Fix hotplug for SDHI1") from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-ap4evb.c
index 95935c83,6c244a8..0000000
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@@ -309,7 -320,8 +322,9 @@@ static struct sh_mobile_sdhi_info sdhi1
  	.dma_slave_tx	= SHDMA_SLAVE_SDHI1_TX,
  	.dma_slave_rx	= SHDMA_SLAVE_SDHI1_RX,
  	.tmio_ocr_mask	= MMC_VDD_165_195,
 +	.tmio_flags	= TMIO_MMC_WRPROTECT_DISABLE,
+ 	.tmio_caps	= MMC_CAP_NEEDS_POLL,
+ 	.get_cd		= slot_cn7_get_cd,
  };
  
  static struct resource sdhi1_resources[] = {
