Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1JKDkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:40:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37596 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1JKDkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:40:22 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEUNAZsaAJBXrfi8+5E5GCK4KFUcOSiZarGEwqz2idT2EA@mail.gmail.com>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
	<20111010172557.332bfe30@lxorguk.ukuu.org.uk>
	<CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
	<CANejiEURP-tuBtCfocNjrs1MgK8NMzQttRkPEWeXJ40fNov20Q@mail.gmail.com>
	<CACVXFVOcSOe+_XpNdKGBCMzdFcs4=ViZbf7hPLnieZUhPewzmA@mail.gmail.com>
	<CANejiEUNAZsaAJBXrfi8+5E5GCK4KFUcOSiZarGEwqz2idT2EA@mail.gmail.com>
Date: Tue, 11 Oct 2011 11:40:21 +0800
Message-ID: <CACVXFVM_KU3Re87FT6k55EKNFXZ-NdhhuUoff8H71s7fWxjTUA@mail.gmail.com>
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

On Tue, Oct 11, 2011 at 10:26 AM, Shaohua Li <shli@kernel.org> wrote:
> 2011/10/11 Ming Lei <tom.leiming@gmail.com>:
>> Hi,
>>
>> On Tue, Oct 11, 2011 at 9:49 AM, Shaohua Li <shli@kernel.org> wrote:
>>
>>> As Alan explained, PM_QOS_CPU_DMA_LATENCY is for dma snooping. For example,
>>> in x86, cpu snoop dma. when cpu is in idle state, cpu need snoop
>>> device dma activity, there
>>> is latency involved for idle state.
>>>
>>
>> I see, thanks for your clarification.
>>
>> I also have two further questions about it:
>>
>> - Except for dma snooping purpose, are there any other cases in which
>> PM_QOS_CPU_DMA_LATENCY is required?
> it's the main motivation, IIRC, don't know other platforms

If so, maybe all device drivers which support DMA transfer should
have used PM_QOS_CPU_DMA_LATENCY, but why only few drivers
did it?

>
>> - Are all CPUs required to be involved to dma snoop? Or only one CPU
>> is enough? If one is enough, maybe we can allow other CPUs to reach
>> deeper idle state.
> then how can you make cache coherency between the cpus?
>

Seems ARM supports cache maintenance operations from software[1],
but I don't know how to do it on x86, :-)


[1], http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dai0228a/index.html


thanks,
-- 
Ming Lei
