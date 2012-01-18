Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab2ARJRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:17:13 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56226 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837Ab2ARJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:12:51 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V2 00/12] dmaengine: Pl08x and dw_dmac updates
Date: Wed, 18 Jan 2012 14:41:47 +0530
Message-ID: <cover.1326876464.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod/Dan,

This patchset does following:
- Includes earlier patchset sent by Rajeev for cleanly applying this patchset
- Adds device_fc (device flow control) field in struct DMA_SLAVE_CONFIG
- Fixes existing users of DMAENGINE for device_fc.
- Updates pl08x driver according to that
- Fixes few issues/bugs in dw_dmac driver
- Adds DMA_SLAVE_CONFIG for dw_dmac driver
- Fixes existing users of dw_dmac driver

Change History:
Since V1:
- used dev_get_platdata() instead of platform_get_drvdata(), as that was
  incorrect
- Lots of fixes in: dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
- Additional patches:
	- dmaengine/dw_dmac: Add 64 bit access width support for slave xfers on
	  mem side
	- Fix other kernel driver for device_fc and dw_dmac changes.

Rebased-on:

commit 3506c0d507144d9b0f19efd5a56d289f70611179
Author: Tushar Behera <tushar.behera@linaro.org>
Date:   Tue Dec 6 16:15:54 2011 +0530

    DMA: PL330: Remove pm_runtime_xxx calls from pl330 probe/remove
    

Rajeev KUMAR (1):
  dmaengine/dw_dmac: Hibernation support in dw_dmac

Viresh Kumar (11):
  dmaengine: Add flow controller information to dma_slave_config
  dmaengine: Pass dma_slave_config .device_fc = NULL for all existing
    users
  dmaengine/amba-pl08x: Take flow controller info from DMA_SLAVE_CONFIG
  dmaengine/dw_dmac: Don't use magic number for total number of
    channels
  dmaengine/dw_dmac: Use dev_get_platdata() instead of accessing dev
    directly
  dmaengine/dw_dmac: Don't handle block interrupts
  dmaengine/dw_dmac: Unmap all memory buffers after completion of slave
    transfers
  dmaengine/dw_dmac: Add 64 bit access width support for slave xfers on
    mem side
  dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
  dmaengine/dw_dmac: Fix dw_dmac user drivers to adapt to slave_config
    changes
  dmaengine/dw_dmac: Remove unused fields in struct dw_dma_slave

 arch/avr32/mach-at32ap/at32ap700x.c             |   13 --
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |    7 -
 drivers/dma/amba-pl08x.c                        |    4 +-
 drivers/dma/dw_dmac.c                           |  232 +++++++++++++++--------
 drivers/dma/dw_dmac_regs.h                      |   15 ++
 drivers/mmc/host/atmel-mci.c                    |   24 ++-
 drivers/mmc/host/mmci.c                         |    2 +
 drivers/mmc/host/mxcmmc.c                       |    2 +
 drivers/spi/spi-dw-mid.c                        |    3 +
 drivers/spi/spi-pl022.c                         |    2 +
 drivers/tty/serial/amba-pl011.c                 |    3 +
 drivers/usb/musb/ux500_dma.c                    |    1 +
 include/linux/amba/pl08x.h                      |    8 +-
 include/linux/dmaengine.h                       |    5 +
 include/linux/dw_dmac.h                         |   38 ----
 sound/atmel/abdac.c                             |   18 ++-
 sound/atmel/ac97c.c                             |   41 ++++-
 sound/soc/imx/imx-pcm-dma-mx2.c                 |    3 +
 18 files changed, 255 insertions(+), 166 deletions(-)

-- 
1.7.8.110.g4cb5d

