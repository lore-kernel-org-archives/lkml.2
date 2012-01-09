Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2AIOVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:21:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44028 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2AIOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:21:47 -0500
Date: Mon, 9 Jan 2012 22:21:28 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, vinod.koul@intel.com, eric.miao@linaro.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org
Subject: Re: [PATCH v4 2/2] dma/imx-sdma: convert _raw_readl/_raw_writel to
 readl/writel
Message-ID: <20120109142125.GA1854@richard-laptop>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
 <1326033862-25351-3-git-send-email-richard.zhao@linaro.org>
 <20120109115143.GL21765@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109115143.GL21765@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 11:51:43AM +0000, Russell King - ARM Linux wrote:
> On Sun, Jan 08, 2012 at 10:44:22PM +0800, Richard Zhao wrote:
> > readl/writel is more genric. And if CONFIG_ARM_DMA_MEM_BUFFERABLE,
> > they includes necessary memory barriers.
> 
> In a DMA engine driver, you need to use the barrier accessors when:
> 
> 1. You finally enable the DMA engine to perform a transfer.
>    The included barrier ensures that writes to the descriptors are visible
>    to the DMA engine.
> 
> 2. You read from a status register before examining the descriptors.
>    This ensures that the descriptor accesses won't be ordered before the
>    status register read.
> 
> Provided other accesses are within the same 1K region, the remainder of
> them do not have to be the strictly ordered accessors, and you can use
> the _relaxed variants (but only in ARM specific drivers.)
> 
> So, if your DMA engine has a control register, and a descriptor pointer
> register, you can write the descriptor pointer register with a
> writel_relaxed().  When you write the control register to enable the
> transfer, use writel() to ensure there's a barrier so the descriptors
> are visible.
Thanks very much for teaching. I understand now what relaxed means here.
I'll change all register access to _relaxed version except in function
sdma_enable_channel.
Freescale power pc also has sdma, I guess we can use _relaxed till they
tend to use the same driver ( I don't know when).

Thanks
Richard
