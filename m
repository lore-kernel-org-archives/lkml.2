Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1ATLSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:18:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58402 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1ATLSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yGi9NFOoyXppTkznz50eJBOry1DkuIdnLZ1jF9aPG2Stc+iCzrjq8bgHbTSjXRGTQJ
         QxdD3BJz94bXS8OlLmYwtzM+i5ppy0zLHxtrqvRuahfYynTMPK4Be6rl3oWi5qOOOPlZ
         OkOdLsB9QJx6JFf9VMoFKp5a4pYqgtY0QzGlM=
MIME-Version: 1.0
In-Reply-To: <1295520247.28776.152.camel@laptop>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	<20110119135546.bb7e8f62.akpm@linux-foundation.org>
	<1295484358.15213.25.camel@yhuang-dev>
	<20110119165247.cca2f434.akpm@linux-foundation.org>
	<1295520247.28776.152.camel@laptop>
Date: Thu, 20 Jan 2011 19:18:12 +0800
Message-ID: <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 6:44 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-01-19 at 16:52 -0800, Andrew Morton wrote:
>> On Thu, 20 Jan 2011 08:45:58 +0800
>> Huang Ying <ying.huang@intel.com> wrote:
>>
>> > On Thu, 2011-01-20 at 05:55 +0800, Andrew Morton wrote:
>> > > I'm trying to remember why we're talking about this.
>> > >
>> > > You had an ACPI-based "hardware error reporting" thing.  And that
>> > > required an nmi-context memory allocator.  And that required a
>> > > "lockless" list implementation.
>> > >
>> > > Yes?
>> >
>> > Yes.  But the "lockless" list implementation is general, it can be used
>> > by other part of kernel too,  such as irq_work and xlist in
>> > net/rds/xlist.h in the patchset.
>>
>> Well.  Lots of things are general but that doesn't mean we toss them
>> into the kernel when we already have plenty of infrastructure to handle
>> that sort of thing.
>>
>> otoh, hoisting xlist.h out of net/rds and making it generally available
>> is a good thing.
>>
>> otooh, net/rds/ probably didn't need xlist at all and could have used
>> existing general code.
>>
>> So...  I'd say that unless and until the NMI-context allocator is
>> merged, the case for merging the lockless list code is a bit marginal?
>> Or have you identified other code sites which could use llist and which
>> would gain some benefit from migrating?
>
> In fact, I have a patch ready and waiting to revert the whole irq_work
> stuff, that too seems to be a superfluous generalization.

What do you plan to replace irq_work?  I plan to use it in APEI NMI
handler and MCE handler.

Best Regards,
Huang Ying
