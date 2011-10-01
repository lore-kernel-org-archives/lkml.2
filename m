Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1JASRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:17:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:6534 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1JASRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,473,1312182000"; 
   d="scan'208";a="73333515"
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <21cnbao@gmail.com>, Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        rmk@arm.linux.org.uk, DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
In-Reply-To: <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317200618.1573.1765.camel@vkoul-udesk3>
	 <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	 <1317295068.1573.1780.camel@vkoul-udesk3>
	 <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	 <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	 <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 23:41:14 +0530
Message-ID: <1317492674.1573.1849.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 11:05 +0800, Barry Song wrote:
> 2011/10/1 Jassi Brar <jaswinder.singh@linaro.org>:
> > On 30 September 2011 12:13, Barry Song <21cnbao@gmail.com> wrote:
> >>
> >> i support we can update dma_data_direction to:   MEM_TO_MEM,
> >> MEM_TO_DEV,  DEV_TO_MEM, DEV_TO_DEV.
> >>
> > So basically you are suggesting to replace 'enum dma_data_direction'
> > with 'enum xfer_direction'
> > I am not sure about that. I think they represent different things and
> > hence should be separate.
> > dma_data_direction tells the mapping of a buffer while the other
> > tells if the src and dst are memory or a device's FIFO.
> >
> you are kind of right now. now people use dma_data_direction to do
> mapping for dma buffer. even with all 4 direction, people still use
> the old two direction to do mapping. For example, it can't use
> MEM_TO_MEM to map, it still need to know whether the memory is source
> or dest.
> 
> i just don't like to the two old macro names. it seems i get a ticket
> flying from New York to Beijing, but actually, we fly to Mexico...
> so by the moment, dma_data_direction seems just to mean how to do map,
> but xfer_direction is the real transfer direction.
> 
> How could we have two macro names: SRC_MEM, DEST_MEM for mapping. or just add:
> dma_map_single_src
> dma_map_single_dst
Direction is valid even if you are doing memory to memory transfer. IMO
what we need to specify what type of transfer (memory or peripheral),
perhaps a flag and use that along with dma_data_direction.

@Jassi, this is what kind of tweak I have in mind. And i do not agree
current approach is bad and is it cleanly tell us type of transfer
(memcpy or prep_sg) and direction with dma_data _direction.

-- 
~Vinod

