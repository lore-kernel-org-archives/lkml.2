Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab0ERSg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:36:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36273 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0ERSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:36:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5986"; a="41868442"
Subject: [GIT PULL] MSM mmc_sdcc driver update
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, San Mehat <san@google.com>,
       Dmitry Shmidt <dimitrysh@google.com>, Roel Kluin <roel.kluin@gmail.com>,
       linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 11:36:03 -0700
Message-ID: <1274207763.29811.45.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some general fixes and updates. It's really more of a re-sync with the
current Google driver.


The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
  Linus Torvalds (1):
        Linux 2.6.33-rc2

are available in the git repository at:

  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-mmc_sdcc

Dmitry Shmidt (1):
      mmc: msm_sdcc: Don't set host->curr.mrq until after we're sure the busclk timer won't fire

Roel Kluin (1):
      msm_sdcc.c: missing brackets in msmsdcc_resume()

San Mehat (15):
      mmc: msm_sdcc: Clean up clock management and add a 10us delay after enabling clocks
      mmc: msm_sdcc: Snoop SDIO_CCCR_ABORT register
      msm: Add 'execute' datamover callback
      mmc: msm_sdcc: Driver clocking/irq improvements
      mmc: msm_sdcc: Wrap readl/writel calls with appropriate clk delays
      mmc: msm_sdcc: Schedule clock disable after probe
      mmc: msm_sdcc: Reduce command timeouts and improve reliability.
      mmc: msm_sdcc: Fix bug where busclk expiry timer was not properly disabled
      mmc: msm_sdcc: Featurize busclock power save and disable it by default
      mmc: msm_sdcc: Fix issue where we might not end a sucessfull request
      mmc: msm_sdcc: Don't disable interrupts while suspending
      mmc: msm_sdcc: Enable busclk idle timer for power savings
      mmc: msm_sdcc: Fix the dma exec function to use the proper delays
      mmc: msm_sdcc: Fix issue where clocks could be disabled mid transaction
      drivers: mmc: msm_sdcc: Add EMBEDDED_SDIO support

 arch/arm/mach-msm/dma.c              |    5 +
 arch/arm/mach-msm/include/mach/dma.h |    2 +
 drivers/mmc/host/msm_sdcc.c          |  476 ++++++++++++++++++++-------------
 drivers/mmc/host/msm_sdcc.h          |   15 +-
 4 files changed, 309 insertions(+), 189 deletions(-)


