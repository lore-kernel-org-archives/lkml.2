Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2GXNB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:01:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40543 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2GXNB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:01:27 -0400
Message-ID: <500E9CC7.9020201@gmail.com>
Date: Tue, 24 Jul 2012 15:01:59 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: dlaor@redhat.com
CC: Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        anthony@codemonkey.ws, wency@cn.fujitsu.com
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical
 events in the device
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com> <87a9yprc4v.fsf@rustcorp.com.au> <500E5C36.2070601@redhat.com> <500E954F.8090102@gmail.com> <500E9942.3080505@redhat.com>
In-Reply-To: <500E9942.3080505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 02:46 PM, Dor Laor wrote:
> On 07/24/2012 03:30 PM, Sasha Levin wrote:
>> On 07/24/2012 10:26 AM, Dor Laor wrote:
>>> On 07/24/2012 07:55 AM, Rusty Russell wrote:
>>>> On Mon, 23 Jul 2012 22:32:39 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
>>>>> As it was discussed recently, there's currently no way for the guest to notify
>>>>> the host about panics. Further more, there's no reasonable way to notify the
>>>>> host of other critical events such as an OOM kill.
>>>>
>>>> I clearly missed the discussion.  Is this actually useful?  In practice,
>>>
>>> Admit this is not a killer feature..
>>>
>>>> won't you want the log from the guest?  What makes a virtual guest
>>>> different from a physical guest?
>>>
>>> Most times virt guest can do better than a physical OS. In that sense, this is where virtualization shines (live migration, hotplug for any virtual resource including net/block/cpu/memory/..).
>>>
>>> There are plenty of niche but worth while small features such as the virtio-trace series and other that allow the host/virt-mgmt to get more insight into the guest w/o a need to configure the guest.
>>>
>>> In theory guest OOM can trigger a host memory hot plug action. Again, I don't see it as a key feature..
>>>
>>>>
>>>> Guest watchdog functionality might be useful, but that's simpler to
>>>
>>> There is already a fully emulated watchdog device in qemu.
>>
>> There is, but why emulate physical devices when you can take advantage of virtio?
>>
>> You could say the same about the rest of the virtio family - "There is already a fully emulated NIC device in qemu".
> 
> The single issue virtio-nic solves is performance enhancements that can be done w/ a fully emulated NIC. The reason is that such NIC tend to access pio/mmio space a lot while virtio is designed for virtualization.

virtio on it's own was introduced to help solve the fragmentation around virtualized devices, so I don't think that the main purpose of doing virtio drivers is due to any performance benefits virtio may provide.

Also consider virtio devices which don't exactly have strict performance considerations such as virtio-9p or virtio-rng.

I mean, why implement virtio-rng when qemu could just emulate some sort of a hardware RNG and just grab randomness from the host?

> Standard watchdog device (isn't it time you'll try qemu?)  isn't about performance and if that's all the functionality you need it should work fine.

Don't understand me wrong, I'm not saying that there's something with the watchdog driver in qemu. All I want is to write a watchdog driver for lkvm which can take advantage of the fact it runs within a guest.

> btw: check the virtio-trace series that was just send in a parallel thread.

Will do!

> Cheers,
> Dor
> 
> 
> 


