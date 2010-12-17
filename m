Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0LQPfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:35:07 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:48278 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0LQPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=onvSd5PQjNWfP3w21IQJtemkfdtN9eVMGfVVIuYmjFXwQVAnN9Dcj2WCVT4M8FWoP/
         VIoc9sKCruROgJzuBzIEJ8oemY7huSlMXPkjoxeoqEMot8Hjj0BT2oeB7Npm/rbJSmCS
         EFMZfe2Gffz9fo6B6ppriNmgdhJ16dyO3UKfA=
MIME-Version: 1.0
In-Reply-To: <1292588555.2266.165.camel@twins>
References: <1292482744-12953-1-git-send-email-ying.huang@intel.com>
	<1292491467.6803.4327.camel@twins>
	<1292545232.12648.1236.camel@yhuang-dev>
	<1292588555.2266.165.camel@twins>
Date: Fri, 17 Dec 2010 23:35:01 +0800
Message-ID: <AANLkTi=6z1bw9iNi2hhDJaSnZVhBDOr_JDD2dAFYKqC_@mail.gmail.com>
Subject: Re: [PATCH -mm -v8 0/3] Lockless memory allocator and list
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Brown,Len" <len.brown@intel.com>, "Luck,Tony" <tony.luck@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 8:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-12-17 at 08:20 +0800, Huang Ying wrote:
>> On Thu, 2010-12-16 at 17:24 +0800, Peter Zijlstra wrote:
>> > On Thu, 2010-12-16 at 14:59 +0800, Huang Ying wrote:
>> > > This patchset adds a lockless memory allocator and a lock-less
>> > > list.
>> >
>> > Still no users the allocator, and no attempt to unify the existing
>> > lockless list implementations.
>> >
>> > I'm getting very tired of this Huang.
>>
>> I just want to do that in the next step after merging the data structure
>> itself. The first user of the allocator is APEI, which will go ACPI
>> tree, lockless list in irq_work will go tip tree, lockless list in xlist
>> will go net tree.
>>
>> We must merge the data structure with its users together?
>
> Yes -- that's how new infrastructure gets merged. Because if we don't
> agree with the users (I don't) there is no point in merging these things
> either.
>
> I would really like you to stop posting code and talk to the EDAC guys.
> You just keep on posting the same crap over and over again without
> making any kind of progress what so ever.
>
> So stop pushing your crap, _please_, and talk to the EDAC and other RAS
> guys and come up with something together.
>
> I haven't heard a single other RAS guy agree with your approach, and I'm
> getting really sick of you just pushing your stuff without even wanting
> to talk to them.
>
> I don't want to see a single line of code from you until you've talked
> with other RAS folks and they agree that your bits make sense.
>
> So let me put it in simple words: unless there's a non-Intel RAS guy
> signing off on your patches I'm objecting to them.

Please take a look at the patchset, this patchset is not RAS specific,
it is not hardware error reporting infrastructure or hardware error
reporting interface. This is just lock-less data structure. So this is
not a RAS patchset. Why I must get non-Intel RAS guys' signing off for
a non-RAS patchset?

I will not post my original hardware error reporting infrastructure or
interface after this patchset. Although I may use some part of this
patchset in APEI code, that is just driver internal data structure
usage, not general hardware error reporting infrastructure or
interface.

> The thing is, a unified RAS infrastructure is much more useful for
> admins, it means they can use the same tools regardless of what platform
> they're running on.
>
> Now I know creating such a thing seems daunting, but at least give it a
> try, its better to have tried and failed that not attempted at all, at
> worst you'll learn what you did wrong and can try to do better the
> second time around.

I have tried to do that with my original hardware error reporting
interface patchset. It is really generic, simple and can help RAS
guys. But it seems that no many people like it, and no many people
really take a look at it. So I stop doing that now.

And I remember the recent consensus on hardware error reporting is to
use printk. Although I think it will be better if we have some other
tool-oriented interface too. I will work on printk based hardware
error reporting interface firstly.

Best Regards,
Huang Ying
