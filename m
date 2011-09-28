Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1I1D06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:26:58 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:35858 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1I1D05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:26:57 -0400
Message-ID: <4E8293C4.5090009@st.com>
Date: Wed, 28 Sep 2011 08:55:56 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Subject: Re: [linux-pm Query] Power Management Device Suspend/ Resume
References: <CAO1yOm2pbApTwa0gj3Q9RsC1mxNGGirxm6FzaDC7zbgjHdkKDw@mail.gmail.com>
In-Reply-To: <CAO1yOm2pbApTwa0gj3Q9RsC1mxNGGirxm6FzaDC7zbgjHdkKDw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Can somebody please help us understand suspend/resume.
It would be a great help, even if you can point us to some earlier fruitful
discussion.

--
viresh

On 9/22/2011 4:19 PM, Deepak Sikri wrote:
> Hi,
>  
> We are in the process of adding Suspend/ Resume call backs for the devices on SPEAr platform.
> The platform makes use of various power domains which could be turned off (during suspend, implying
> the devices in those power domains lose their context).
>  
> *There are certain queries*.
>  
> *Query- 1*. Suppose my platform has a ADC driver under char framework, which internally uses the
> DMA driver (channels). Now, ADC driver can be used by other kernel drivers or directly from user application.
>  
> *1. a.* What are the expectations from the suspend and resume routines of both the devices, DMA & ADC ?
>  
> */-- Given that few of the options are/*
> */1.a.1. On suspend,/*
> In ADC suspend function: ADC releases all the DMA channels, latches its registers; and
> DMA suspend function: DMA does nothing except for lataching of registers if required.
>  
> */1.a.2. On suspend, /*
> ADC suspend function: ADC just latches its registers and stops R/W through DMA, no DMA channel release;
> DMA suspend function: DMA halts its operating channels, and latches its registers if required.
>  
> */1.a.3 Some other alternative/*
> *//* 
>  
> *1.b* Will the suspend resume for the dependent drivers follow sequencing, i.e. Suspend of ADC followed by
> Suspend of DMA? (Assume both of these devices are hooked on to Platform bus, given that ADC uses DMA)
>  
> *Query-2*
>  
> 2.1 The user space threads freeze first followed by kernel space.  In case the user space process issues a a system
> call (lets assume an ioctl system call), how will the user space thread respond in case of suspend to ram?
>  
> 2.2 Will the kernel thread running on behalf of user space process complete the ioctl call OR 
>  freeze upon in the middle of execution?
>  
> *Query-3*
> ** 
> Are there any modalities w.r.t latching and restoring the contents at the driver level ?
> that is: Should this process be handled at drier level or platform specific code can also handle this
>  
>  
> Thanks & Regards
> Deepak
