Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1I2LXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:23:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:48645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1I2LXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:23:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,460,1312182000"; 
   d="scan'208";a="68601845"
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
In-Reply-To: <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317200618.1573.1765.camel@vkoul-udesk3>
	 <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 16:47:48 +0530
Message-ID: <1317295068.1573.1780.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 20:45 +0530, Jassi Brar wrote:
> >> +enum xfer_direction {
> >> +     MEM_TO_MEM,
> >> +     MEM_TO_DEV,
> >> +     DEV_TO_MEM,
> >> +     DEV_TO_DEV,
> > Use/update dma_data_direction.
> dma_data_direction is the mapping attribute of a buffer.
> While that info is what some dmac driver might need ultimately, our
> main aim here is to tell exactly if Src and Dst is Memory or a
> device's FIFO.
> 
> Mapping attribute of src/dst buffers could be very well deducted from
> xfer_direction, but dma_data_direction isn't meant to tell if Src and
> Dst is Mem or FIFO.
> Also, for (SLAVE && !src_inc && !dst_inc) we need to disambiguate
> three options  Mem->Fifo,  Fifo->Mem,  *Fifo->Fifo*(not impossible)
> So while using dma_data_direction would work today, that sure is hacky
> and not future-proof.
That is why I said use/update, you missed the update part.

One way would be to use direction field with new flag indicating if its
memory or device transfer, otherwise you can expand this enum.

Point is few things are already there so improve upon it rather than
have two structures in kernel doing similar things...

-- 
~Vinod

