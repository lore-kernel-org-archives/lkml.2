Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2ABLvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:51:17 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:59335 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064Ab2ABLvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:51:15 -0500
Message-ID: <4F019A19.3060701@st.com>
Date: Mon, 2 Jan 2012 17:20:49 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
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
References: <4EE038BD.7010705@st.com>  <1323329870.1641.27.camel@vkoul-udesk3> <4EE06C3C.8080003@st.com>  <4EE8469B.8050201@st.com> <4EE97E77.8060703@st.com>  <8D3F6266AEB6384E807C6FFC6FE195E327F2B0@BGSMSX101.gar.corp.intel.com>  <4EE98478.5070209@st.com>  <4EE99A15.8010608@st.com>  <1324372895.1641.10087.camel@vkoul-udesk3>  <4EF0602C.4070001@st.com> <1325504133.1540.26.camel@vkoul-udesk3>
In-Reply-To: <1325504133.1540.26.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/2012 5:05 PM, Vinod Koul wrote:
> On Tue, 2011-12-20 at 15:45 +0530, Pratyush Anand wrote:
>> >  On 12/20/2011 2:51 PM, Vinod Koul wrote:
>>> >  >  On Thu, 2011-12-15 at 12:26 +0530, Pratyush Anand wrote:
>>>>>> >  >>>>  That way existing mechanism would work well for you.
>>>>>> >  >>>>  You need to split the chunks properly, which is what dma would do
>>>> >  >>  anyway
>>>>>> >  >>>>
>>>>> >  >>>
>>>>> >  >>>  Yes, they can be split like this, but then splitting onus will go on
>>>> >  >>  dma
>>>>> >  >>>  user driver, and so there would be replication of similar logic at
>>>>> >  >>>  several places. Therefore, I was thinking to make device_prep_dma_sg
>>>> >  >>  as
>>>>> >  >>>  generic by adding these flags.
>>> >  >  Well I am not sure how adding flags handles this?
>> >
>> >  device_prep_dma_sg has last argument as flags. dma user driver can pass
>> >  information about inc/dec of src/dst in this flag, which can be used by
>> >  the dma driver. I have put one such implementation at the end of mail.
> with the split pre-done would we need to do this, hence the referred
> implementation.
>

even with pre-done, some flag in this function will be needed. Because 
HW also need o know whether to src and dst are in incrementing or 
decrementing order.



