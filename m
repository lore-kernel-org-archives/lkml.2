Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1JCQOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:14:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43131 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab1JCQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:14:05 -0400
Date: Mon, 3 Oct 2011 17:13:49 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
Message-ID: <20111003161349.GB28287@flint.arm.linux.org.uk>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org> <1317200618.1573.1765.camel@vkoul-udesk3> <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com> <1317295068.1573.1780.camel@vkoul-udesk3> <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com> <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com> <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com> <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com> <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com> <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:54:23AM +0530, Jassi Brar wrote:
> On 2 October 2011 06:03, Barry Song <21cnbao@gmail.com> wrote:
> > 2011/10/2 Jassi Brar <jaswinder.singh@linaro.org>
> 
> >> > For example, it can't use
> >> > MEM_TO_MEM to map, it still need to know whether the memory is source
> >> > or dest.
> >> MEM_TO_MEM means "From Memory Source To Memory Destination"
> >>  Map Src buffer with DMA_TO_DEVICE and Dst buffer with DMA_FROM_DEVICE
> >>
> >> MEM_TO_DEV means "From Memory Source To FIFO Destination"
> >>  Map Src buffer with DMA_TO_DEVICE.
> >>
> >> DEV_TO_MEM means "From FIFO Source To Memory Destination"
> >>  Map Dst buffer with DMA_FROM_DEVICE
> >>
> >> DEV_TO_DEV means "From FIFO Source To FIFO Destination"
> >>
> >> What else would you want to know ?
> >
> > that is the problem. for example, drivers can't use MEM_TO_MEM as a
> > flag to do dma mapping. so xfer_direction can't cover all that
> > dma_data_direction can do.  that's why you need both
> > dma_data_direction and xfer_direction with some similar flags in them.
> >
> The client drivers map the src/dst buffers and the dmac driver unmaps
> them by default(!). For which, the dmac driver doesn't look at anything
> other than
>      DMA_COMPL_SKIP_SRC/DST_UNMAP
>      DMA_COMPL_SRC/DST_UNMAP_SINGLE
>   bits of 'enum dma_ctrl_flags'.
> For this unmap'ing purpose, the usage of dma_data_direction is already
> internal to the dmac driver.

No.  Slave DMA engine drivers do *not* (and if they do, they should *not*)
honour the unmapping of submitted buffers.

The unmapping of these buffers by the DMA engine driver is intended to be
done for the async_tx API and not slave DMA.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
