Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1G2KuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:50:05 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:48991 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391Ab1G2KuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:03 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH 00/18] dmaengine/amba-pl08x updates
Date: Fri, 29 Jul 2011 16:19:10 +0530
Message-ID: <cover.1311936523.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset contains patches for ARM's pl08x DMA controller driver.
Main changes introduced by this patchset are:
- Formatting fixes
- Logical Fixes
- Support for Peripheral as flow controller
- Support for sg_len to be greater than 1 for slave transfers
- Schedule tasklet for error interrupts
- remove pl08x_pre_boundary() routine
- etc

This patchset is tested on SPEAr600 for following tests:
- memory to memory copy (using drivers/dma/dmatest, upto 16 threads per channel)
- peripheral to memory and vice versa (Peripheral: JPEG)

This was rebased on Vinod's slave-dma.git/next, over following patch:

commit 1ae105aa7416087f2920c35c3cd16831d0d09c9c
Merge: 02f8c6a 5a42fb9
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed Jul 27 20:43:21 2011 +0530

    Merge branch 'next' into for-linus-3.0


Viresh Kumar (18):
  ARM: asm/pl080.h: Protect against multiple inclusion of header file
  dmaengine/amba-pl08x: Resolve formatting issues
  dmaengine/amba-pl08x: Complete doc comment for struct pl08x_txd
  dmaengine/amba-pl08x: Remove redundant comment and rewrite original
  dmaengine/amba-pl08x: Changing few prints to dev_dbg from dev_info
  dmaengine/amba-pl08x: Simplify pl08x_ensure_on()
  dmaengine/amba-pl08x: Enable/Disable amba_pclk with channel requests
  dmaengine/amba-pl08x: No need to check "ch->signal < 0"
  dmaengine/amba-pl08x: Schedule tasklet in case of error interrupt
  dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
  dmaengine/amba-pl08x: max_bytes_per_lli is TRANSFER_SIZE * src_width
    (not MIN(width))
  dmaengine/amba-pl08x: Add prep_single_byte_llis() routine
  dmaengine/amba-pl08x: Align lli_len to max(src.width, dst.width)
  dmaengine/amba-pl08x: Choose peripheral bus as master bus
  dmaengine/amba-pl08x: Pass flow controller information with slave
    channel data
  dmaengine/amba-pl08x: Add support for sg len greater than one for
    slave transfers
  dmaengine/amba-pl08x: Check txd->llis_va before freeing dma_pool
  dmaengine/amba-pl08x: Call pl08x_free_txd() instead of calling
    kfree() directly

 arch/arm/include/asm/hardware/pl080.h |    4 +
 drivers/dma/amba-pl08x.c              |  671 ++++++++++++++++-----------------
 include/linux/amba/pl08x.h            |   33 ++-
 3 files changed, 347 insertions(+), 361 deletions(-)

-- 
1.7.2.2

