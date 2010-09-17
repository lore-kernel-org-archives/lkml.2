Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0IQCh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:37:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33669 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0IQCh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BKJBikRyay6Q0B1hNb9F57Cm42nCn9/wp+PSH+yjXJrxb2RqYRgb6qMZfK9vWxs9mg
         dlr9q1fpgyB+wlbDxrG8wx3+ZlWY4OD+L69OZpWbBXMJyc1Z8SBjXOBafVPfEmXtZ0zS
         TFwRUyg5eMUZ3aefyW2nbkTHyuCgRV0ncEyUQ=
MIME-Version: 1.0
Date: Thu, 16 Sep 2010 22:37:24 -0400
Message-ID: <AANLkTimFUgZoKBXk_weOG_AMtW8Y0g6Q8-QvH8hnfv8z@mail.gmail.com>
Subject: additional esx events (was Re: [PATCH] VMware Balloon: rename module)
From: Chetan Loke <chetanloke@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 8:31 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
>> >> side note - is it possible to extend the balloon driver to get a
>> >> notification on other events? like CPUs, NICs? Just an event is what
>> >> I'm looking for. No action need to be taken in the guest.
>> >
>> > No, balloon driver should be limited to ballooning. I think the data
>> > you are looking for can be retrieved via GuestSDK (and I believe we
>> > are adding balloon_target to the available data).
>>
>> No. I think the guestSDK provides the guest, it's personal view of the
>> world, no?
>> http://www.vmware.com/support/developer/guest-sdk/
>
> Right since guest is supposed to be isolated.

pv != isolation and ballooning isn't either ;). But let's not get into that.


>
> There is vSphere SDK that shoudl allow you to connect to the hostd and
> get more information about the host/VC:
>
> http://www.vmware.com/support/developer/viperltoolkit/
>
perl API? why? vmware_balloon driver already has the hooks. So a
parallel driver can have the same
basic implementation. I'm not looking for any fancy notifications.
Even if we emit sysfs nodes, it's
perfectly fine. It will be a one-way read only channel.I am willing to test it.

>
>>
>> ballooning is an indirect hint that an external event has happened
>> within the hypervisor. I'm looking for similar external events.
>> guestSDK gives nothing. Because right now there is now way for a
>> vmware-guest to cooperate or be a good citizen if it
>> doesn't know what's happening in the esx-hypervisor. Now whether to
>> add these events in the balloon driver is another thing.
>> A separate driver is ok too.
>
> I spoke with resource management team regarding this idea of a VM
> "helping" ESX and they felt that this task is better left to the
> ESX's memory scheduler. The VM in question will not know all the
> data needed (it might be confined to a separate resource pool, etc)
> to make good decision.

ok, so its not just about freeing resources but I've agents(within
VMs) running on esx hypervisor.
So by getting CPU/NIC/Memory events I can log those and raise soft alarms to
a central monitoring node.


>
> Still you could use Guest SDK - if you see balloon target rising you
> may start unlocking memory you grabbed.
>
ballooning does nothing to guests who have mmap'd memory and drivers
who have pinned down pages.
And forcibly releasing(aka soft illegal OOM?) someone else's mmap'd
memory will never be allowed.
Anyways, the use case is also for monitoring and not just for freeing resources.


> Dmitry

regards
Chetan Loke
