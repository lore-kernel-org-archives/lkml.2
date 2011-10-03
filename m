Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1JCSXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:23:17 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64597 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1JCSXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:23:09 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwshrNc3dmzZ+nXSA4ZXO5OgvNwEApKTGW4ieSKu_YC5sw@mail.gmail.com>
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
	<CABE8wwshrNc3dmzZ+nXSA4ZXO5OgvNwEApKTGW4ieSKu_YC5sw@mail.gmail.com>
Date: Mon, 3 Oct 2011 23:53:08 +0530
Message-ID: <CAJe_Zhc2hY0dZRRZrZMzrasnvZ-+c32gB2oaGdK0mtA6GcOQew@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2011 22:45, Williams, Dan J <dan.j.williams@intel.com> wrote:
> On Mon, Oct 3, 2011 at 9:19 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> On 3 October 2011 21:43, Russell King <rmk@arm.linux.org.uk> wrote:
>>> On Mon, Oct 03, 2011 at 11:54:23AM +0530, Jassi Brar wrote:
>>>> On 2 October 2011 06:03, Barry Song <21cnbao@gmail.com> wrote:
>>>> > 2011/10/2 Jassi Brar <jaswinder.singh@linaro.org>
>>>>
>>>> >> > For example, it can't use
>>>> >> > MEM_TO_MEM to map, it still need to know whether the memory is source
>>>> >> > or dest.
>>>> >> MEM_TO_MEM means "From Memory Source To Memory Destination"
>>>> >>  Map Src buffer with DMA_TO_DEVICE and Dst buffer with DMA_FROM_DEVICE
>>>> >>
>>>> >> MEM_TO_DEV means "From Memory Source To FIFO Destination"
>>>> >>  Map Src buffer with DMA_TO_DEVICE.
>>>> >>
>>>> >> DEV_TO_MEM means "From FIFO Source To Memory Destination"
>>>> >>  Map Dst buffer with DMA_FROM_DEVICE
>>>> >>
>>>> >> DEV_TO_DEV means "From FIFO Source To FIFO Destination"
>>>> >>
>>>> >> What else would you want to know ?
>>>> >
>>>> > that is the problem. for example, drivers can't use MEM_TO_MEM as a
>>>> > flag to do dma mapping. so xfer_direction can't cover all that
>>>> > dma_data_direction can do.  that's why you need both
>>>> > dma_data_direction and xfer_direction with some similar flags in them.
>>>> >
>>>> The client drivers map the src/dst buffers and the dmac driver unmaps
>>>> them by default(!). For which, the dmac driver doesn't look at anything
>>>> other than
>>>>      DMA_COMPL_SKIP_SRC/DST_UNMAP
>>>>      DMA_COMPL_SRC/DST_UNMAP_SINGLE
>>>>   bits of 'enum dma_ctrl_flags'.
>>>> For this unmap'ing purpose, the usage of dma_data_direction is already
>>>> internal to the dmac driver.
>>>
>>> No.  Slave DMA engine drivers do *not* (and if they do, they should *not*)
>>> honour the unmapping of submitted buffers.
>>>
>>> The unmapping of these buffers by the DMA engine driver is intended to be
>>> done for the async_tx API and not slave DMA.
>>>
>> The proposed api is usable by both Slave as well as Async(Memcpy etc).
>> So it *does* matter here.
>
> I think the confusion is reduced if you don't try to use this api for
> mem-to-mem transfers.  Then you can use DMA_NONE to indicate the
> dev-to-dev case.  If a mem-to-mem user arrives we can revisit
> xfer_direction, but as it stands it seems this is primarily useful for
> slave-dma, i.e. I don't see async_tx_dma or net_dma switching to this
> scheme anytime soon, if ever.  Are there other mem-to-mem use cases
> that would use this?
>
As a matter of fact, I personally ever only needed such api for MemToMem
- converting a peculiar YUV arrangement to a more 'normal' one using PL330.
Barry's is the first real Slave requirement I came across(not to mean I wasn't
expecting).
So IMO, limiting the api to only Slave, is not much better than having Vendor
specific api because chances are we might not see another 'interleaved' user
of it real soon.


> Also in dmaxfer_template I do not understand the need for src_inc and
> dst_inc.  Aren't those properties that the client would know about the
> slave device?
>
You are assuming only Slave usage.
src_inc/dst_inc are mainly for 'Memset' type operation.
In Slave transfer they would help avoid allocating full length RX buffer
when the client only wants to send data but the controller works
only in full-duplex and vice-versa (thanks to RMK for pointing the case,
and I remember S3C24XX do have such SPI controller).
More generally when one needs to transmit the same data, or discard
the received data, for a certain period of time.

Good to have you in the discussion.
