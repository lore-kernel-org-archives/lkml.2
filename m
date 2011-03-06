Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1CFUNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:13:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:28334 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab1CFUNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:13:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,272,1297065600"; 
   d="scan'208";a="664414993"
Subject: Re: [PATCH V2 00/13] dmaengine/dw_dmac: Extending support & minor
 fixes
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, amit.goel@st.com, armando.visconti@st.com,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        viresh.linux@gmail.com, jamie@jamieiles.com,
        hans-christian.egtvedt@atmel.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 01:15:20 +0530
Message-ID: <1299440720.6974.158.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 15:47 +0530, Viresh Kumar wrote:
> Following set of patches extends dw_dmac support and fixes minor bugs.
> 
> Changes since V1:
> I had few more patches that i prepared today. I wasn't sure if i should
> add them to existing patchset, but as they are very much associated to this
> patchset, i added them here.
> 
> Following new patches have been added in V2:
> - dw_dmac: Replace module_init() with subsys_initcall()
> - dw_dmac: Change value of DWC_MAX_COUNT to 4095
> - dw_dmac: Changing type of src_master and dest_master to u8
> - dw_dmac: Setting Default Burst length for transfers as 16
> - Allow src/dst msize & flow controller to be configured at runtime
> - at32ap700x: Specify DMA Flow Controller, Src and Dst msize or burst size
> 
> Other than this following are changes after getting review comments on V1:
> - Added driver dependency on HAVE_CLK & fixed commit message issues
> - Added descriptive commit message in: "Calling dwc_scan_descriptors from..."
> - Aligned struct instance in: "Mark all tx_descriptors with..." 
> - Removed: "dw_dmac: call dwc_scan_descriptor from dwc_issue_pending..." as it
>   was already commited in linux-next.
> 
> Viresh KUMAR (1):
>   dw_dmac: Allow src/dst msize & flow controller to be configured at
>     runtime
> 
> Viresh Kumar (12):
>   dw_dmac: Remove compilation dependency from AVR32 and put on HAVE_CLK
>   dw_dmac: Replace module_init() with subsys_initcall()
>   dw_dmac: Move single descriptor from dwc->queue to dwc->active_list
>     in dwc_complete_all
>   dw_dmac: Calling dwc_scan_descriptors from dwc_tx_status() after
>     taking lock
>   dw_dmac: Adding support for 64 bit access width for memcpy xfers
>   dw_dmac: Change value of DWC_MAX_COUNT to 4095.
>   dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK after xfer finish
>   dw_dmac: Pass Channel Allocation Order from platform_data
>   dw_dmac: Pass Channel Priority from platform_data
>   dw_dmac: Changing type of src_master and dest_master to u8.
>   dw_dmac: Setting Default Burst length for transfers as 16.
>   avr32: at32ap700x: Specify DMA Flow Controller, Src and Dst msize or
>     burst size
> 
>  arch/avr32/mach-at32ap/at32ap700x.c |    9 +++++
>  drivers/dma/Kconfig                 |    2 +-
>  drivers/dma/dw_dmac.c               |   67 +++++++++++++++++++++++------------
>  drivers/dma/dw_dmac_regs.h          |    4 ++
>  include/linux/dw_dmac.h             |   43 +++++++++++++++++++++--
>  5 files changed, 98 insertions(+), 27 deletions(-)
> 
Thanks, Applied this series (13) and readl/writel fixes patch

-- 
~Vinod

