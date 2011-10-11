Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1JKJgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:36:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43395 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1JKJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEXACbyvq=_ChAsb7D3ZoBQtqs6uS-s7NPU26e3X-tyPLA@mail.gmail.com>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
	<20111010172557.332bfe30@lxorguk.ukuu.org.uk>
	<CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
	<CANejiEURP-tuBtCfocNjrs1MgK8NMzQttRkPEWeXJ40fNov20Q@mail.gmail.com>
	<CACVXFVOcSOe+_XpNdKGBCMzdFcs4=ViZbf7hPLnieZUhPewzmA@mail.gmail.com>
	<CANejiEUNAZsaAJBXrfi8+5E5GCK4KFUcOSiZarGEwqz2idT2EA@mail.gmail.com>
	<CACVXFVM_KU3Re87FT6k55EKNFXZ-NdhhuUoff8H71s7fWxjTUA@mail.gmail.com>
	<CANejiEXACbyvq=_ChAsb7D3ZoBQtqs6uS-s7NPU26e3X-tyPLA@mail.gmail.com>
Date: Tue, 11 Oct 2011 17:36:39 +0800
Message-ID: <CACVXFVOqzr4S0-pFG_09Z47PugCWuDxLnGQX9AFm_QGEv3StgQ@mail.gmail.com>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
From: Ming Lei <tom.leiming@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 11, 2011 at 1:32 PM, Shaohua Li <shli@kernel.org> wrote:
> 2011/10/11 Ming Lei <tom.leiming@gmail.com>:
>> Hi,
>>
>> On Tue, Oct 11, 2011 at 10:26 AM, Shaohua Li <shli@kernel.org> wrote:
>>> 2011/10/11 Ming Lei <tom.leiming@gmail.com>:
>>>> Hi,
>>>>
>>>> On Tue, Oct 11, 2011 at 9:49 AM, Shaohua Li <shli@kernel.org> wrote:
>>>>
>>>>> As Alan explained, PM_QOS_CPU_DMA_LATENCY is for dma snooping. For example,
>>>>> in x86, cpu snoop dma. when cpu is in idle state, cpu need snoop
>>>>> device dma activity, there
>>>>> is latency involved for idle state.
>>>>>
>>>>
>>>> I see, thanks for your clarification.
>>>>
>>>> I also have two further questions about it:
>>>>
>>>> - Except for dma snooping purpose, are there any other cases in which
>>>> PM_QOS_CPU_DMA_LATENCY is required?
>>> it's the main motivation, IIRC, don't know other platforms
>>
>> If so, maybe all device drivers which support DMA transfer should
>> have used PM_QOS_CPU_DMA_LATENCY, but why only few drivers
>> did it?
> depends on your device. Say cpu takes 1s to snoop dma in idle state, so device
> dma will cost more than 1s. if your device can work with such latency, no
> problem then.
>

Sorry, I am still a bit confused.

As you said before, for x86, some deep cpu idle states may stop dma
snoop, so introduce PM_QOS_CPU_DMA_LATENCY to prevent cpuidle from
entering such kind of deep idle state if I/O dma is in progress.  I
understand the cpu dma pm qos should always be applied before starting
any dma transfer, Otherwise, cpu local cache may not be updated after
dma is over when cpu is returned from the deep idle state.

If so, the latency is only related with the exit latency of cpu idle
state in which dma snoop is stopped, instead of being related with I/O
devices.

Please correct me if the above is wrong.


thanks,
-- 
Ming Lei
