Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2DJJsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:48:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54635 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2DJJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:48:10 -0400
Message-ID: <4F8401D6.4030404@suse.cz>
Date: Tue, 10 Apr 2012 11:48:06 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: daniel@ffwll.ch, Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Jiri Slaby <jirislaby@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <20120409101119.47e770b2@jbarnes-desktop> <4F83F3B5.8080704@suse.cz> <20120410085820.GC4115@phenom.ffwll.local>
In-Reply-To: <20120410085820.GC4115@phenom.ffwll.local>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 10:58 AM, Daniel Vetter wrote:
> On Tue, Apr 10, 2012 at 10:47:49AM +0200, Jiri Slaby wrote:
>> On 04/09/2012 07:11 PM, Jesse Barnes wrote:
>>> On Fri, 30 Mar 2012 11:45:43 +0100 Chris Wilson
>>> <chris@chris-wilson.co.uk> wrote:
>>>
>>>> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz>
>>>> wrote:
>>>>> I don't know what to dump more, because iir is obviously zero
>>>>> too. What other sources of interrupts are on the (G33) chip?
>>>>
>>>> IIR is the master interrupt, with chained secondary interrupt
>>>> statuses. If IIR is 0, the interrupt wasn't raised by the GPU.
>>>
>>> I've actually seen cases where one of the PIPE*STAT regs is stuck,
>>> and even if IIR is 0 we still get interrupts... Jiri can you verify
>>> the PIPE*STAT regs have bits set, maybe one or more we don't check
>>> for?
>>
>> Note that I already attached their contents... This is what is in them
>> (pipes 0 and 1):
>> [ 3572.968581] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3572.977472] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3576.224839] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3576.243558] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3576.384912] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3576.403462] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3577.464100] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3577.477383] i915_driver_irq_handler: 0=00000000 1=00000000
>> [ 3577.829016] i915_driver_irq_handler: 0=00020000 1=00000000
>> [ 3577.830093] i915_driver_irq_handler: 0=00020000 1=00000000
>>
>> I.e. the handler is called when IIR=0 and both pipe stats are 0.
> 
> Hm, can you also dump the PORT_HOTPLUG_STAT register? That's the only
> other subordinate interrupt source left.

It's always 0x300:
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000
i915_driver_irq_handler: HP=00000300 0=00000000 1=00000000

thanks,
-- 
js
suse labs

