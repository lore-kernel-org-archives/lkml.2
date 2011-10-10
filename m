Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1JJKwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:52:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:64668 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1JJKwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:52:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,516,1312182000"; 
   d="scan'208";a="60607019"
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <CAJe_ZheDWAeisyOxFVmhWgZCi5qx8QL1_L+YttFrzWxSHyceug@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317200618.1573.1765.camel@vkoul-udesk3>
	 <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	 <1317295068.1573.1780.camel@vkoul-udesk3>
	 <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	 <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	 <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	 <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	 <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	 <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	 <20111003161349.GB28287@flint.arm.linux.org.uk>
	 <CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	 <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	 <1317966346.1573.2252.camel@vkoul-udesk3>
	 <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	 <1317997177.1573.2275.camel@vkoul-udesk3>
	 <CAJe_ZhdSRmQmHOyOSvzyduu1pxR5K3aSd+1fCW2TB36=1ZwUUg@mail.gmail.com>
	 <1318229592.1573.2298.camel@vkoul-udesk3>
	 <CAJe_ZhcWUjdh-LGuAaDAbSYNYrV5dzsrkpCGCeYo6y38pNac4g@mail.gmail.com>
	 <1318238296.1546.3.camel@vkoul-udesk3>
	 <CAJe_ZheDWAeisyOxFVmhWgZCi5qx8QL1_L+YttFrzWxSHyceug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 16:15:01 +0530
Message-ID: <1318243501.1546.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 15:23 +0530, Jassi Brar wrote:
> On 10 October 2011 14:48, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Mon, 2011-10-10 at 14:46 +0530, Jassi Brar wrote:
> >> On 10 October 2011 12:23, Vinod Koul <vinod.koul@intel.com> wrote:
> >> >
> >> > +struct dmaxfer_memcpy_template {
> >> > +       dma_addr_t src_start;
> >> > +       dma_addr_t dst_start;
> >> > +       bool src_inc;
> >> > +       bool dst_inc;
> >> > +       bool src_sgl;
> >> > +       bool dst_sgl;
> >> > +       size_t numf;
> >> > +       size_t frame_size;
> >> > +       struct data_chunk sgl[0];
> >> > +};
> >> > +
> >> > +struct dmaxfer_slave_template {
> >> > +       dma_addr_t mem;
> >> > +       bool mem_inc;
> >> > +       size_t numf;
> >> > +       size_t frame_size;
> >> > +       struct data_chunk sgl[0];
> >> > +};
> >> >
> >> (1) Please tell how is dmaxfer_slave_template supposed to work on
> >>  bi-directional channels?
> >>  Keeping in mind, dma_slave_config.direction is marked to go away
> >>  in future.
> > I didn't use dma_slave_config.direction. There is direction field in
> > corresponding prepare function.
> >
> ok but why not reduce 1 argument from api and embed that as
> the transfer's property in dmaxfer_slave_template, as I did ?
I am not religious about it, doesn't matter either way :)
> 
> >>
> >> (2)
> >>   * slave_template.mem  <=>  memcpy_template.src_start
> >>   * slave_template.mem_inc  <=>  memcpy_template.src_inc
> >>
> >>  So essentially
> >>   memcpy_template  :=  slave_template + src/dst_sgl + dst_start + dst_inc
> >>
> >>  Even after this separation, there is nothing slave specific in
> >> dmaxfer_slave_template. The slave client still needs DMA_SLAVE_CONFIG
> >> to specify slave parameters of the transfer.
> >>  You only save a few bytes in a _copy_ of memcpy_template.
> > Yes DMA_SLAVE_CONFIG is always required, this attempt was not aimed to
> > remove that, but I would be interested in it :)
> >
> Sorry then I don't see this "ambiguity"(if there really is any) removal worth
> adding an extra prepare when we already have 10 of them.
For slave we have only two, and we can easily merge cyclic by adding a
flag or something, I planning to do that for next merge cycle.

IMO having one more for interleaved-slave should be okay.

But I am fine if we find a common ground and merge the two where dmac
can cleanly identify direction and mode it is operating.

-- 
~Vinod

