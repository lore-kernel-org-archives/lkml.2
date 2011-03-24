Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab1CXHRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:17:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44428 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab1CXHRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jO/dun3aniqe2LUBHmBucbhpay0bEvfxAEtnUzmQp2oHcX8iec2mr9j3hOrj/PiRDO
         K0IOB0hrX/AU/i0ZGBViwV0BHd80u6xHqXZNiFHLasJZa8eFGJRoF1KmP1BMvtcrtCgh
         Pfpr+S+tRtt5/PDbQSonacQKWmYZnmMZfLBZQ=
MIME-Version: 1.0
In-Reply-To: <20110323145418.GE13315@redhat.com>
References: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
	<20110323142505.GD13315@redhat.com>
	<AANLkTi=EoPKcBE1miW_-RHgHTBCSDKJ1My=Z40rrhm1x@mail.gmail.com>
	<20110323145418.GE13315@redhat.com>
Date: Thu, 24 Mar 2011 08:17:33 +0100
Message-ID: <AANLkTik3kXkfkm=x54VwGrhy5GUOpVY_DSsXTVFMhaR5@mail.gmail.com>
Subject: Re: Support for global block IO throttling?
From: Juerg Haefliger <juergh@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi Vivek,
>>
>> >> Are there any plans to support global (per cgroup) IO throttling in
>> >> the near future? I'm in need of this and would gladly work on it if
>> >> nobody else is and if people think this is a useful feature. What I
>> >> envision is that one can specify the limits of individual devices in a
>> >> group but also specify the overall aggregate limit of the whole group.
>> >> I just started looking at the throttling code and haven't quite
>> >> figured it out yet so it might take me a bit to get up to speed.
>> >
>> > Hi Juerg,
>> >
>> > What's the use case? Why do you need global block IO throttling?
>>
>> Resource management for guest VMs. I want to make sure a VM cannot
>> exceed a certain IO limit. If the VM does IOs to only one device, it
>> gets the full specified bandwidth to that single device but if the VM
>> talks to multiple devices, it only gets a fraction of the global
>> bandwidth per device, not exceeded the global limit.
>
> Can't we specify per device limit for VM if VM is doing IO to multiple
> devices?

Yes we can but it's not exact. As I mentioned, the way I want to
specify it is so that the VMs alloted bandwidth is shared across all
the drives presented to that VM.

> I know it is not exact replacement of global limits as one has to know
> the topology and figure out to what all devices IO is happening. This
> might get even more difficult if VM's disk is a file on filesystem on
> host and not a device directly eported to guest.
>
> Somebody also had mentioned that if we have mutiple layers of qemu
> snapshots and if snapshots are sitting on different logical devices
> then it becomes hard to figure out where all VM traffic is going
> and how to even divide global limits in per device limits
>
> Also current IO controller does not work for NFS. So if a global limit
> is imposed in higher layers it will solve that issue too.
>
> Also if you implement it above page cache then it should automatically
> handle the case of async writes too. The downside is that if limits
> are low, buffered writers will be throttled very frequently.
>
> So in general, I think global limits is a useful concept. Do you have
> a implementation ready?

Err... No... I was hoping the community can give me some pointers and
infos to get me started. Just like the details you mentioned above
which are very useful.

Thanks
...Juerg


> Thanks
> Vivek
>
