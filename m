Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0IQANf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:13:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60077 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0IQANe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WIPJk0c8dYdMgmrXZyt8REalAdHEmShyDtmUVBN25J0HNOQqA7T9Web/3BpEh1EPL8
         RBofHeDpxnw5zL8z3uDghMV2j6zD+c8mHMm6ph1S8W48TzND8Jsb7r8HGkej6XewwLHF
         yCpCL/WWrgmmEzChRD5FXkQK7OMlYBiaijKj0=
MIME-Version: 1.0
In-Reply-To: <201009161623.14722.dtor@vmware.com>
References: <AANLkTikWmwVvWzRMK7yvtyqYbd4OeeR1nLsP1OAxbnJg@mail.gmail.com>
	<201009161623.14722.dtor@vmware.com>
Date: Thu, 16 Sep 2010 20:13:32 -0400
Message-ID: <AANLkTinokTUuShVEokYyJApj26CBD-q+xma_55rgdZEM@mail.gmail.com>
Subject: Re: [PATCH] VMware Balloon: rename module
From: Chetan Loke <chetanloke@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 7:23 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
> Hi Chetan,
Hi

>> > In an effort to minimize customer confusion we want to unify naming
>> > convention for VMware-provided kernel modules. This change renames
>> > the balloon driver from vmware_ballon to vmw_balloon.
>>
>> What will vmtools name its vmware_balloon driver to? vmw_balloon, correct?
>
> That is the plan.

I will have to change my scripts/iso's if there's a mismatch. If
there's a mismatch then will we end up w/ 2 drivers?
Or will vmtools cleanup the past residue?
We prep'd a 2.6.35 iso. Now while updating I will have to wrap a
special case to account for balloon-renaming.
The case that I'm worried about is this:
1) 2.6.35 - vmware_balloon
2) upgrade kernel - now vmw_balloon
3) install vmtools  - a new vmware_balloon(?) if this version of
vmtools didn't pick up the change?
Is there a workaround?

Sorry, not being a pain but we have had some tough time with
vmtool-upgrades+udev+vmxnet and vnic addition/deletion recently.


>
>>
>> > +   vmballoon_wq = create_freezeable_workqueue("vmmemctl");
>>
>> minor change - vmware_vmmemctl?
>
> I do not think this needs to be changed; it does not have to match
> the module name, plus, given Tejun's changes, it will all be generic
> [worker/u:X] soon anyway.
>
ok.


>>
>> side note - is it possible to extend the balloon driver to get a
>> notification on other events? like CPUs, NICs? Just an event is what
>> I'm looking for. No action need to be taken in the guest.
>
> No, balloon driver should be limited to ballooning. I think the data
> you are looking for can be retrieved via GuestSDK (and I believe we
> are adding balloon_target to the available data).
>

No. I think the guestSDK provides the guest, it's personal view of the
world, no?
http://www.vmware.com/support/developer/guest-sdk/

ballooning is an indirect hint that an external event has happened
within the hypervisor. I'm looking for similar external events.
guestSDK gives nothing. Because right now there is now way for a
vmware-guest to cooperate or be a good citizen if it
doesn't know what's happening in the esx-hypervisor. Now whether to
add these events in the balloon driver is another thing.
A separate driver is ok too.

> Thanks.
> Dmitry

thanks
cloke
