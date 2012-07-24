Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2GXI0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:26:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab2GXI0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:26:45 -0400
Message-ID: <500E5C36.2070601@redhat.com>
Date: Tue, 24 Jul 2012 11:26:30 +0300
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Sasha Levin <levinsasha928@gmail.com>, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        anthony@codemonkey.ws, wency@cn.fujitsu.com
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical
 events in the device
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com> <87a9yprc4v.fsf@rustcorp.com.au>
In-Reply-To: <87a9yprc4v.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 07:55 AM, Rusty Russell wrote:
> On Mon, 23 Jul 2012 22:32:39 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
>> As it was discussed recently, there's currently no way for the guest to notify
>> the host about panics. Further more, there's no reasonable way to notify the
>> host of other critical events such as an OOM kill.
>
> I clearly missed the discussion.  Is this actually useful?  In practice,

Admit this is not a killer feature..

> won't you want the log from the guest?  What makes a virtual guest
> different from a physical guest?

Most times virt guest can do better than a physical OS. In that sense, 
this is where virtualization shines (live migration, hotplug for any 
virtual resource including net/block/cpu/memory/..).

There are plenty of niche but worth while small features such as the 
virtio-trace series and other that allow the host/virt-mgmt to get more 
insight into the guest w/o a need to configure the guest.

In theory guest OOM can trigger a host memory hot plug action. Again, I 
don't see it as a key feature..

>
> Guest watchdog functionality might be useful, but that's simpler to

There is already a fully emulated watchdog device in qemu.
Cheers,
Dor

> implement via a virtio watchdog device, and more effective to implement
> via a host facility that actually pings guest functionality (rather than
> the kernel).
>
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


