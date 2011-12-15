Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab1LOE6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 23:58:48 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:36314 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab1LOE6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 23:58:47 -0500
Message-ID: <4EE97E77.8060703@st.com>
Date: Thu, 15 Dec 2011 10:28:31 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>, <linus.walleij@linaro.org>
Subject: Re: dmaengine/Query: What about scatter/gather for mem to mem transfers.
References: <4EE038BD.7010705@st.com> <1323329870.1641.27.camel@vkoul-udesk3> <4EE06C3C.8080003@st.com> <4EE8469B.8050201@st.com>
In-Reply-To: <4EE8469B.8050201@st.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vinod/Dan,

Please write your opinion.

Regards
Pratyush

On 12/14/2011 12:17 PM, Pratyush Anand wrote:
> Hello Vinod/Dan,
>
> In continuation to the scatter/gather requirement:
> We might need some generic transfer where source and destination address
> may be overlapped and also gap between two chunk of source and
> destination might not be same.
>
> For examaple,
> Transfer size is - -0x4000
> Our Src is something like this:
> 0x1000 -- 0x2000
> 0x3000 -- 0x5000
> 0x6000 -- 0x7000
>
> and dst is something like this:
> 0x6000 -- 0x8000
> 0x9000 -- 0xB000
>
> It seems that device_prep_interleaved_dma would not be able to handle
> such transfer.
>
> So, what I was thinking that to add following flags in enum dma_ctrl_flags.
>
> DMA_SRC_INC = (1 << 10),
> DMA_SRC_DEC = (2 << 10),
> DMA_SRC_FIX = (3 << 10),
> DMA_DST_INC = (1 << 12),
> DMA_DST_DEC = (2 << 12),
> DMA_DST_FIX = (3 << 12),
>
> Now we can use these flag in device_prep_dma_sg and this function can be
> implemented for generic cases.
>
> I think, the above modifications will not affect other's platform and
> should be acceptable.
>
> Whats your opinion?
>
> Regards
> Pratyush
>
> On 12/8/2011 1:20 PM, Viresh KUMAR wrote:
>> On 12/8/2011 1:07 PM, Vinod Koul wrote:
>>> You mean something like:
>>> struct dma_async_tx_descriptor *(*device_prep_dma_sg)(
>>> struct dma_chan *chan,
>>> struct scatterlist *dst_sg, unsigned int dst_nents,
>>> struct scatterlist *src_sg, unsigned int src_nents,
>>> unsigned long flags);
>>>
>>> Its already there, you need to implement in your driver :)
>>
>> Ok. I didn't knew it. :(
>>
>

