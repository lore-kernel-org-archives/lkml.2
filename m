Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1JLGx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:53:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62024 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1JLGxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <1318400368.1546.372.camel@vkoul-udesk3>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
 <1317200618.1573.1765.camel@vkoul-udesk3> <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
 <1317295068.1573.1780.camel@vkoul-udesk3> <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
 <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
 <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
 <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
 <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
 <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
 <20111003161349.GB28287@flint.arm.linux.org.uk> <CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
 <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
 <1317966346.1573.2252.camel@vkoul-udesk3> <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
 <1317997177.1573.2275.camel@vkoul-udesk3> <CAJe_ZhdSRmQmHOyOSvzyduu1pxR5K3aSd+1fCW2TB36=1ZwUUg@mail.gmail.com>
 <1318229592.1573.2298.camel@vkoul-udesk3> <CAJe_ZhcWUjdh-LGuAaDAbSYNYrV5dzsrkpCGCeYo6y38pNac4g@mail.gmail.com>
 <1318238296.1546.3.camel@vkoul-udesk3> <CAJe_ZheDWAeisyOxFVmhWgZCi5qx8QL1_L+YttFrzWxSHyceug@mail.gmail.com>
 <1318243501.1546.12.camel@vkoul-udesk3> <CAJe_Zhd0xVULcEd2t5DwofmjPNrxOi3bUjMVDRF5N4+47kUiJw@mail.gmail.com>
 <1318262559.1546.31.camel@vkoul-udesk3> <CAJe_ZhcYiu1ZAWBGww2tysP5K_QwmoRNtfMZ9t2erRXhHY5W0A@mail.gmail.com>
 <CAGsJ_4zzN1erduhV_hwWpPgTQ-YFowoPpmC_CKaT_C2=63OtZg@mail.gmail.com> <1318400368.1546.372.camel@vkoul-udesk3>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 12 Oct 2011 14:53:34 +0800
Message-ID: <CAGsJ_4x4CQep2V3u0o83MWra_CJXdE6aQoENSnnziVBkqnVbNA@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
To: Vinod Koul <vinod.koul@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/12 Vinod Koul <vinod.koul@intel.com>:
> On Wed, 2011-10-12 at 13:41 +0800, Barry Song wrote:
>> 2011/10/11 Jassi Brar <jaswinder.singh@linaro.org>:
>> > On 10 October 2011 21:32, Vinod Koul <vinod.koul@intel.com> wrote:
>> >> On Mon, 2011-10-10 at 16:46 +0530, Jassi Brar wrote:
>> >>> On 10 October 2011 16:15, Vinod Koul <vinod.koul@intel.com> wrote:
>> >>> >
>> >>> > But I am fine if we find a common ground and merge the two where dmac
>> >>> > can cleanly identify direction and mode it is operating.
>> >>> >
>> >>> The client would set the xfer_direction and dmac would interpret as
>> >>>
>> >>> enum xfer_direction {
>> >>>      MEM_TO_MEM,   ->  Async/Memcpy mode
>> >>>      MEM_TO_DEV,    ->  Slave mode & From Memory to Device
>> >>>      DEV_TO_MEM,    ->  Slave mode & From Device to Memory
>> >>>      DEV_TO_DEV,     ->  Slave mode & From Device to Device
>> >>> }
>> >>>
>> >>> How could it get any cleaner?
>> >> Consider the case of a dmac driver which supports interleaved dma as
>> >> well as memcpy and slave
>> >> It needs to interpret dma_data_direction for later cases and
>> >> xfer_direction for former ones.
>> > dma_data_direction is the mapping attribute of a buffer and is not meant to
>> > tell type of source and destination of a transfer.
>> > xfer_direction is meant for that purpose.
>> > So I'd rather convert device_prep_dma_cyclic and device_prep_slave_sg
>> > to use xfer_direction.
>>
>> i tend to agree with Jassi. now dma_data_direction actually is only
>> mapping things not real transfer direction.
>> xfer_direction is now something really telling the data transfer direction.
>> I think that's what device_prep_dma_cyclic and device_prep_slave_sg want.
>>
>> actually, there is only one case we need to use dma_data_direction in
>> dmac driver, that's unmapping async dma buffer.
>> But the param to dma_unmap_single can be implied by xfer_direction and
>> dma description.
>>
>> that's why i think we should rename dma_data_direction to
>> dma_map_direction or something like that to avoid confusion.
> Nope, I would leave dma_data_direction as is.
> We should use above enum in dmaengine and all dmac drivers.

anyway, the rename issue is trivial. i can accept the current name as
is even it doesn't make all senses.
The important thing is the dma_transfer_direction or
dma_xfer_direction as Jassi and you said.

>
> @Jassi: I have started doing this change for dmaengine and dmacs, and I
> took the liberty to name this enum as dma_transfer_direction, hope you
> are okay with that
>
>
> --
> ~Vinod
>
-barry
