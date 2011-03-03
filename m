Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab1CCKSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:18:21 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:47502 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796Ab1CCKST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:19 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 00/13] dmaengine/dw_dmac: Extending support & minor fixes
Date: Thu, 3 Mar 2011 15:47:13 +0530
Message-ID: <cover.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following set of patches extends dw_dmac support and fixes minor bugs.

Changes since V1:
I had few more patches that i prepared today. I wasn't sure if i should
add them to existing patchset, but as they are very much associated to this
patchset, i added them here.

Following new patches have been added in V2:
- dw_dmac: Replace module_init() with subsys_initcall()
- dw_dmac: Change value of DWC_MAX_COUNT to 4095
- dw_dmac: Changing type of src_master and dest_master to u8
- dw_dmac: Setting Default Burst length for transfers as 16
- Allow src/dst msize & flow controller to be configured at runtime
- at32ap700x: Specify DMA Flow Controller, Src and Dst msize or burst size

Other than this following are changes after getting review comments on V1:
- Added driver dependency on HAVE_CLK & fixed commit message issues
- Added descriptive commit message in: "Calling dwc_scan_descriptors from..."
- Aligned struct instance in: "Mark all tx_descriptors with..." 
- Removed: "dw_dmac: call dwc_scan_descriptor from dwc_issue_pending..." as it
  was already commited in linux-next.

Viresh KUMAR (1):
  dw_dmac: Allow src/dst msize & flow controller to be configured at
    runtime

Viresh Kumar (12):
  dw_dmac: Remove compilation dependency from AVR32 and put on HAVE_CLK
  dw_dmac: Replace module_init() with subsys_initcall()
  dw_dmac: Move single descriptor from dwc->queue to dwc->active_list
    in dwc_complete_all
  dw_dmac: Calling dwc_scan_descriptors from dwc_tx_status() after
    taking lock
  dw_dmac: Adding support for 64 bit access width for memcpy xfers
  dw_dmac: Change value of DWC_MAX_COUNT to 4095.
  dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK after xfer finish
  dw_dmac: Pass Channel Allocation Order from platform_data
  dw_dmac: Pass Channel Priority from platform_data
  dw_dmac: Changing type of src_master and dest_master to u8.
  dw_dmac: Setting Default Burst length for transfers as 16.
  avr32: at32ap700x: Specify DMA Flow Controller, Src and Dst msize or
    burst size

 arch/avr32/mach-at32ap/at32ap700x.c |    9 +++++
 drivers/dma/Kconfig                 |    2 +-
 drivers/dma/dw_dmac.c               |   67 +++++++++++++++++++++++------------
 drivers/dma/dw_dmac_regs.h          |    4 ++
 include/linux/dw_dmac.h             |   43 +++++++++++++++++++++--
 5 files changed, 98 insertions(+), 27 deletions(-)

-- 
1.7.2.2

