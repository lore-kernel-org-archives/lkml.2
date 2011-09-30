Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1I3Gnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:43:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1I3Gnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <1317295068.1573.1780.camel@vkoul-udesk3>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
 <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
 <1317200618.1573.1765.camel@vkoul-udesk3> <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
 <1317295068.1573.1780.camel@vkoul-udesk3>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 30 Sep 2011 14:43:10 +0800
Message-ID: <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
To: Vinod Koul <vinod.koul@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/29 Vinod Koul <vinod.koul@intel.com>:
> On Wed, 2011-09-28 at 20:45 +0530, Jassi Brar wrote:
>> >> +enum xfer_direction {
>> >> +     MEM_TO_MEM,
>> >> +     MEM_TO_DEV,
>> >> +     DEV_TO_MEM,
>> >> +     DEV_TO_DEV,
>> > Use/update dma_data_direction.
>> dma_data_direction is the mapping attribute of a buffer.
>> While that info is what some dmac driver might need ultimately, our
>> main aim here is to tell exactly if Src and Dst is Memory or a
>> device's FIFO.
>>
>> Mapping attribute of src/dst buffers could be very well deducted from
>> xfer_direction, but dma_data_direction isn't meant to tell if Src and
>> Dst is Mem or FIFO.
>> Also, for (SLAVE && !src_inc && !dst_inc) we need to disambiguate
>> three options  Mem->Fifo,  Fifo->Mem,  *Fifo->Fifo*(not impossible)
>> So while using dma_data_direction would work today, that sure is hacky
>> and not future-proof.
> That is why I said use/update, you missed the update part.
>
> One way would be to use direction field with new flag indicating if its
> memory or device transfer, otherwise you can expand this enum.
>
> Point is few things are already there so improve upon it rather than
> have two structures in kernel doing similar things...

i support we can update dma_data_direction to:   MEM_TO_MEM,
MEM_TO_DEV,  DEV_TO_MEM, DEV_TO_DEV.

Russell gave a good explain about the mapping decided by MEM_TO_DEV
and  DEV_TO_MEM. Then even a memory-to-memory DMA will require
MEM_TO_DEV/DEV_TO_MEM flag to do mapping because only
MEM_TO_DEV/DEV_TO_MEM can decide what dma_map_single() class functions
will operate on cache. But that is really a bad idea to users. To
users, i just want DMA_TO_DEV to be a DMA which transfers data from
memory to device. otherwise, it should have a different name. I think
how to map buffer is just a software detail. but the DMA_TO_DEV should
be a right description to the real world.

anyway, the update can be a seperate patch not in this one.

>
> --
> ~Vinod

-barry
