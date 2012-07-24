Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2GXMW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:22:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46345 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2GXMW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:22:58 -0400
Message-ID: <500E93BC.8010600@gmail.com>
Date: Tue, 24 Jul 2012 14:23:24 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mst@redhat.com, penberg@kernel.org, asias.hejun@gmail.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        anthony@codemonkey.ws, wency@cn.fujitsu.com
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical
 events in the device
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com> <87a9yprc4v.fsf@rustcorp.com.au>
In-Reply-To: <87a9yprc4v.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 06:55 AM, Rusty Russell wrote:> On Mon, 23 Jul 2012 22:32:39 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
>> As it was discussed recently, there's currently no way for the guest to notify
>> the host about panics. Further more, there's no reasonable way to notify the
>> host of other critical events such as an OOM kill.
>
> I clearly missed the discussion.  Is this actually useful?  In practice,
> won't you want the log from the guest?  What makes a virtual guest
> different from a physical guest?

I'll try answering all of those questions:

My usecase for it is to help out with getting automatic debug output out of a problematic guest. I run a KVM tools guest which runs the trinity fuzzer within it. Once in a while, it finds something which causes the guest to misbehave (oops/panic/etc). At that point, the guest hangs there waiting for me to come and do something about it. With this device, I could automate that procedure and possibly make this entire bug hunting process fully automatic.

Now, I'm aware that this use case is probably not too common out there, but since there is a patch which tries to do the but by creating a whole new guest-host interface skipping virtio (https://lkml.org/lkml/2012/7/21/14), I guess this is useful in the real world as well.

Regarding the log, there are many ways to have that right now (good old serial/virtio-serial/etc), the issue is that I want to be notified of critical guest events and grepping the log sounds like the wrong way.

The difference between physical and virtual guest in this regard is by how much useful data I can retrieve out of a problem guest rather easily, and by things which which can occur as a result of these events (for example, add some memory if OOMs are happening frequently - which is not possible on physical hardware).

> Guest watchdog functionality might be useful, but that's simpler to
> implement via a virtio watchdog device, and more effective to implement
> via a host facility that actually pings guest functionality (rather than
> the kernel).

I agree that this echo functionality doesn't really belong in the notifier and would probably work better as a separate virtio-watchdog. Would it make sense to split this code into a virtio-notifier and virtio-watchdog?

