Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1LOFYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:24:22 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51321 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab1LOFYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:24:21 -0500
Message-ID: <4EE98478.5070209@st.com>
Date: Thu, 15 Dec 2011 10:54:08 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: dmaengine/Query: What about scatter/gather for mem to mem transfers.
References: <4EE038BD.7010705@st.com> <1323329870.1641.27.camel@vkoul-udesk3> <4EE06C3C.8080003@st.com> <4EE8469B.8050201@st.com> <4EE97E77.8060703@st.com> <8D3F6266AEB6384E807C6FFC6FE195E327F2B0@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <8D3F6266AEB6384E807C6FFC6FE195E327F2B0@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 10:36 AM, Koul, Vinod wrote:
>>
>> Hello Vinod/Dan,
>>
>> Please write your opinion.
> I am on vacation, but will reply briefly here, more next week

Thanks for your quick reply.

>>
>> Regards
>> Pratyush
>>
>> On 12/14/2011 12:17 PM, Pratyush Anand wrote:
>>> Hello Vinod/Dan,
>>>
>>> In continuation to the scatter/gather requirement:
>>> We might need some generic transfer where source and destination
>>> address may be overlapped and also gap between two chunk of source and
>>> destination might not be same.
>>>
>>> For examaple,
>>> Transfer size is - -0x4000
>>> Our Src is something like this:
>>> 0x1000 -- 0x2000
>>> 0x3000 -- 0x5000
>>> 0x6000 -- 0x7000
>>>
>>> and dst is something like this:
>>> 0x6000 -- 0x8000
>>> 0x9000 -- 0xB000
> So why can't it be split like:
> 0x1000--0x2000 =>  0x6000 --0x7000
> 0x3000 -- 0x4000 =>  0x7000 - 0x8000
> 0x4000 -- 0x5000 =>  0x9000 - 0xA000
> 0x6000 -- 0x7000 =>  0xA000 - 0xB000
>
> That way existing mechanism would work well for you.
> You need to split the chunks properly, which is what dma would do anyway
>

Yes, they can be split like this, but then splitting onus will go on dma 
user driver, and so there would be replication of similar logic at 
several places. Therefore, I was thinking to make device_prep_dma_sg as 
generic by adding these flags.

Regards
Pratyush

> --
> ~Vinod

