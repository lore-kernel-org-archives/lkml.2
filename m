Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2ARKlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:41:13 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:39609 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790Ab2ARKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:41:12 -0500
Message-ID: <4F16A1B3.5000409@st.com>
Date: Wed, 18 Jan 2012 16:10:51 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>
Subject: Re: [PATCH 2/8] dmaengine: Add flow controller information to dma_slave_config
References: <cover.1326707233.git.viresh.kumar@st.com> <5f9ec59562e86536c4123f61891b95590293030f.1326707233.git.viresh.kumar@st.com> <CACRpkdY4QQK6wtB5aPU+FwdyyGq-owsDxMmxdwJVnkzdJTRs_Q@mail.gmail.com> <4F153A3A.7060902@st.com> <CACRpkdbwZ5h15b0gBJP6xdk5TJt+CSeNRbEB8o2vzp9FbyD9AA@mail.gmail.com>
In-Reply-To: <CACRpkdbwZ5h15b0gBJP6xdk5TJt+CSeNRbEB8o2vzp9FbyD9AA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/2012 4:06 PM, Linus Walleij wrote:
> On Tue, Jan 17, 2012 at 10:07 AM, Viresh Kumar <viresh.kumar@st.com> wrote:
>> On 1/17/2012 2:07 PM, Linus Walleij wrote:

> Maybe I should say that it's supposed to transfer information from
> the driver to the DMA engine that:
> 
> 1) The driver naturally "knows", like which physical register address
>   the FIFO is in or burst width etc and the DMA engine has no
>   business knowing.
> 
> 2) That needs to change at runtime, like for example how the PL022
>  driver request 32, 16 or 8 bit wide transfers depending on bus
>  width.
> 
> I think master mode could very well be under (1). So the driver knows
> if this hardware expects the DMA engine to drive the transaction or
> if it's the device itself that should drive it.
> 
> So I'm starting to think like you :-)

:)

>> One more thing. I missed few things in this patch:
>> - Need to update all instances of struct dma_slave_config with
>>        .device_fc = false
> 
> All statically defined structs contain zero == false by default
> so it's not needed.
> 
> Make sure any dynamic allocations (I don't know of any!)
> are kzalloc() though.
> 

I already fixed these in V2.
Most of the drivers created inside routines. They are not getting
initialized to _zero_ , so i had to fix it.

There are few though, who used kzalloc. I didn't touch them.

-- 
viresh
