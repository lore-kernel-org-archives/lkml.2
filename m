Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab1JKBtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 21:49:50 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61218 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1JKBts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 21:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
	<20111010172557.332bfe30@lxorguk.ukuu.org.uk>
	<CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
Date: Tue, 11 Oct 2011 09:49:47 +0800
X-Google-Sender-Auth: qtW7CW41pDR7kmj8M7vqVg5KlpM
Message-ID: <CANejiEURP-tuBtCfocNjrs1MgK8NMzQttRkPEWeXJ40fNov20Q@mail.gmail.com>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
From: Shaohua Li <shli@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/11 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> On Tue, Oct 11, 2011 at 12:25 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Mon, 10 Oct 2011 22:31:34 +0800
>> Ming Lei <tom.leiming@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> Looks like it is a bit difficult to understand PM_QOS_CPU_DMA_LATENCY
>>> from the words' meaning.
>>>
>>> After searching from google, I don't find some useful information about
>>> the root cause for introducing PM_QOS_CPU_DMA_LATENCY. I understand
>>> it is very similar to interrupt latency. Also from the comment for
>>> omap_pm_set_max_mpu_wakeup_lat in file[1], the description is basically same
>>> with interrupt latency.
>>>
>>> >From comments of pm_qos_add_request usages in drivers, it can be understood
>>> as interrupt latency too, IMO.
>>>
>>> So, could we think that PM_QOS_CPU_DMA_LATENCY is interrupt latency?
>>
>> No. Well it may be on some platforms but it isn't the same thing. On some
>> devices a DMA transfer doesn't need the CPU involved but needs the CPU to
>> respond within a set timescale (eg for coherency or bus arbitration). It
>
> I understand only the CPU can respond after it is notified by a
> interrupt event,
> don't I?
As Alan explained, PM_QOS_CPU_DMA_LATENCY is for dma snooping. For example,
in x86, cpu snoop dma. when cpu is in idle state, cpu need snoop
device dma activity, there
is latency involved for idle state.
