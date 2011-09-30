Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1I3PrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:47:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48597 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1I3PrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:47:09 -0400
MIME-Version: 1.0
In-Reply-To: <1317295068.1573.1780.camel@vkoul-udesk3>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	<1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
Date: Fri, 30 Sep 2011 21:17:07 +0530
Message-ID: <CAJe_Zhcf1tp2ukE3tqcrzyfEp1jA5Gw=ed1xDQT6FLYn-jR2ug@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 September 2011 16:47, Vinod Koul <vinod.koul@intel.com> wrote:
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
>
I don't think dma_data_direction should be messed with here.
Or I am just being ignorant, in that case please do suggest how do
you want dma_data_direction "updated" ?
