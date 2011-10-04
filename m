Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1JDNLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:11:40 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32885 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab1JDNLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <4E8B04D8.5010107@redhat.com>
References: <4E82017C.3010304@redhat.com>
	<CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
	<4E8215B6.1020108@redhat.com>
	<20110930001633.GA11436@myri.com>
	<4E882E34.8040409@redhat.com>
	<20111003045823.GA13222@myri.com>
	<4E898A69.8060306@redhat.com>
	<20111003151158.GA21955@myri.com>
	<4E8AD5F4.7000201@redhat.com>
	<4E8B04D8.5010107@redhat.com>
Date: Tue, 4 Oct 2011 08:11:33 -0500
Message-ID: <CAPoiz9zTQqJoskVBK-gN9tjWpes7YrBnXBvAoDWdHhiFfSAH3g@mail.gmail.com>
Subject: Re: Workaround for Intel MPS errata
From: Jon Mason <mason@myri.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 8:06 AM, Avi Kivity <avi@redhat.com> wrote:
> On 10/04/2011 11:46 AM, Avi Kivity wrote:
>>
>> On 10/03/2011 05:12 PM, Jon Mason wrote:
>>>
>>>     PCI: Workaround for Intel MPS errata
>>>
>>>     Intel 5000 and 5100 series memory controllers have a known issue if
>>> read
>>>     completion coalescing is enabled (the default setting) and the PCI-E
>>>     Maximum Payload Size is set to 256B.  To work around this issue,
>>> disable
>>>     read completion coalescing if the MPS is 256B.
>>>
>>>     It is worth noting that there is no function to undo the disable of
>>> read
>>>     completion coalescing, and the performance benefit of read completion
>>>     coalescing will be lost if the MPS is set from 256B to 128B.  It is
>>> only
>>>     possible to have this issue via hotplug removing the only 256B MPS
>>>     device in the system (thus making all of the other devices in the
>>> system
>>>     have a performance degradation without the benefit of any 256B
>>>     transfers).  Therefore, this trade off is acceptable.
>>>
>>>
>>> http://www.intel.com/content/dam/doc/specification-update/5000-chipset-memory-controller-hub-specification-update.pdf
>>>
>>> http://www.intel.com/content/dam/doc/specification-update/5100-memory-controller-hub-chipset-specification-update.pdf
>>>
>>>     Thanks to Jesse Brandeburg and Ben Hutchings for providing insight
>>> into
>>>     the problem.
>>>
>>>     Reported-by: Avi Kivity<avi@redhat.com>
>>>     Signed-off-by: Jon Mason<mason@myri.com>
>>>
>>> +
>>> +        if (!(val&  (1<<  10))) {
>>> +            done = true;
>>> +            return;
>>> +        }
>>
>> Here, you bail out if bit 10 is clear.  So if we're here, it's set.
>>
>>> +
>>> +        val |= (1<<  10);
>>
>> Now it's even more set?
>>
>
> Even with this line changed to clear bit 10, I still get a hard lockup.  Do

That stinks, thanks for finding that issue and fixing it.

> we need to clear this bit on the other 5000 devices?  I notice they have
> similar values in word 0x48, with bits 10 set in them.
>
> What does "Device 7-2,0" refer to in the workaround description?  Seems to
> me we need to apply the workaround to the PCIe ports as well.

I have no idea what that means, but it would make sense.  I'll modify
the patch to do this as well.  Thanks for being so much help :)

>
> --
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
