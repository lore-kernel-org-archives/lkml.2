Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0FOLWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:22:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:56886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab0FOLWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:22:03 -0400
Message-ID: <4C176206.90305@kernel.org>
Date: Tue, 15 Jun 2010 13:20:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
References: <1276443098-20653-1-git-send-email-tj@kernel.org> 	<1276443098-20653-13-git-send-email-tj@kernel.org> <20100614214122.GA21064@suse.de> 	<4C16A48A.2070404@kernel.org> <4C16AAEE.5090204@kernel.org> <AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com>
In-Reply-To: <AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 11:20:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kay.

On 06/15/2010 12:30 PM, Kay Sievers wrote:
>> Hmm... maybe what we can do is generating an uevent when an IRQ is
>> confirmed to be bad and then let udev notify the user.  That way we'll
>> probably have better chance of getting bug reports and users have
>> whiny but working system.
> 
> Not really, uevents are not picked up by anything that could report an
> error to userspace, they are just seen by udev. Also uevents are
> usually not the proper passing method. They are not meant to ever
> transport higher frequency events, or structured data. They cause to
> run the entire udev rule matching machine, and update symlinks and
> permissions with every event.

Oh, these will be very low frequency event.  At most once per
irq_expect or irqaction.  e.g. on a machine with four hard drives, it
can only happen four times after boot unless the driver is unloaded
and reloaded, so from frequency standpoint it should be okay.

> We will need some better error reporting facility. On Linux you don't
> even get notified when the kernel mounts your filesystem read-only
> because of an error. It will only end up in 'dmesg' as a pretty much
> undefined bunch of words. :)

That one is a very low frequency too.

> We will need some generic error reporting facility, with structured
> data exported, and where userspace stuff can subscribe to.
> Uevents/udev can not really properly provide such infrastructure.
> Maybe that can be extended somehow, but using kobject_uevent() and
> trigger the usual udev rule engine is not what we are looking for, for
> sane error reporting.

It's true that there are higher frequency events which will be
horrible to report via kobject_uevent().  Hmmm... but the thing is
that events which should annoy the user by userland notification can't
be definition high freq.  There's only so many users can recognize and
respond, so the frequency limitation of uevent might actually fit here
although it would be nice to have some kind of safety mechanism.
Still no go for uevent?

Thanks.

-- 
tejun
