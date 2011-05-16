Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1EPQhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:37:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:52462 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab1EPQhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:37:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,375,1301900400"; 
   d="scan'208";a="2876254"
Subject: Re: [PATCH V5 0/5] dmaengine/dw_dmac updates
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com,
        linux-arm-kernel@lists.infradead.org, viresh.linux@gmail.com
In-Reply-To: <cover.1304928776.git.viresh.kumar@st.com>
References: <cover.1304928776.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:34:11 +0530
Message-ID: <1305561851.28926.70.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 13:45 +0530, Viresh Kumar wrote:
> This patchset fixes few issues and extends its support.
> 
> Changes in V5:
>  - [PATCH 1/5] rearranging code in dmaengine/dw_dmac: don't call callback
>    routine in case dmaengine_terminate_all() is called
> 
> Changes in V4:
>  - spin_locks are not taken anymore from parent routines. Now every routine
>    takes locks whenever required.
>  - 1 and 0 are replaced with true and false for bool parameters to routines.
>  - flags are not used uninitialized for spin_lock_irqsave
> 
> Changes in V3:
>  - lflags is removed from dw_dma_chan and local flag variables are created.
>  - An extra argument is added to routines calling dwc_descriptor_complete()
>    directly or indirectly
>  - spin_lock() in tasklet is also changed to irqsave variants.
> 
> Changes in V2:
>  - lflags added in dw_dma_chan instead of dw_dma
>  - Patch from Linus Walleij added for pause and resume functionality.
> 
> Linus Walleij (1):
>   dmaengine/dw_dmac: implement pause and resume in dwc_control
> 
> Viresh Kumar (4):
>   dmaengine/dw_dmac: don't call callback routine in case
>     dmaengine_terminate_all() is called
>   dmaengine/dw_dmac: set residue as total len in dwc_tx_status if
>     status is !DMA_SUCCESS
>   dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater
>     than DWC_MAX_COUNT
>   dmaengine/dw_dmac: Replace spin_lock* with irqsave variants and
>     enable submission from callback
> 
>  drivers/dma/dw_dmac.c      |  267 +++++++++++++++++++++++++++++---------------
>  drivers/dma/dw_dmac_regs.h |    1 +
>  2 files changed, 176 insertions(+), 92 deletions(-)
> 
Applied, thanks

-- 
~Vinod

