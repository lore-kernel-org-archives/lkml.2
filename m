Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1JKK4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:56:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49846 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1JKK4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <20111011110728.13004b1c@lxorguk.ukuu.org.uk>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
	<20111010172557.332bfe30@lxorguk.ukuu.org.uk>
	<CACVXFVNAFTpZEOnH+6LxUk=dXtNKvmYVx5NtuJJ1bri4XEyt5Q@mail.gmail.com>
	<20111011110728.13004b1c@lxorguk.ukuu.org.uk>
Date: Tue, 11 Oct 2011 18:56:03 +0800
Message-ID: <CACVXFVODp5o0=+6pwG+K_LV=rtCJo-5J3Os10orwijZJq4r4Ng@mail.gmail.com>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 6:07 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > No. Well it may be on some platforms but it isn't the same thing. On some
>> > devices a DMA transfer doesn't need the CPU involved but needs the CPU to
>> > respond within a set timescale (eg for coherency or bus arbitration). It
>>
>> I understand only the CPU can respond after it is notified by a
>> interrupt event, don't I?
>
> The instruction stream being executed maybe, but not things like the cache
>
>> Also could you give a example about how the CPU responds to a DMA transfer
>> within a set timescale if it is required?
>
> The kind of thing you are dealing with is
>
>        DMA engine requests a cache line of data
>        CPU wakes out of sleep, completes bus transaction

I think the CPU should be woken up by interrupt from DMA engine, so
it is still a kind of interrupt latency?

Also looks like it is a bit odd that why CPU is involved to complete the
bus transaction which should have been done by DMA engine only.
Is there a practical example about this?

>        CPU goes back to sleep
>        DMA engine starts outputting data bits over SPI bus or similar
>
>        repeat until done
>
> so it's not instruction level stuff, merely bus traffic.
>


thanks,
-- 
Ming Lei
