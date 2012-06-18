Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab2FRWRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:17:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2FRWRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120618221535.GA13037@kroah.com>
References: <20120618165336.48345227c6b64c314326ae57@canb.auug.org.au>
 <4FDF61A7.3050601@xenotime.net> <20120619080109.b28055c1b32fb81027a9562b@canb.auug.org.au>
 <20120618221535.GA13037@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 19 Jun 2012 00:17:01 +0200
Message-ID: <CAPXgP10sBkwLnhDmu6UG9yVaiXG+8UYGkBEOVzUp3H+468J03w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 18 (kmsg problems)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 12:15 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 19, 2012 at 08:01:09AM +1000, Stephen Rothwell wrote:
>> [Adding Greg and Kay]
>>
>> On Mon, 18 Jun 2012 10:13:11 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >
>> > on x86_64:
>> >
>> > arch/x86/kernel/reboot.o: In function `kmsg_dump_get_line':
>> > reboot.c:(.text+0xf0): multiple definition of `kmsg_dump_get_line'
>> > arch/x86/kernel/setup.o:setup.c:(.text+0x0): first defined here
>> > arch/x86/kernel/reboot.o: In function `kmsg_dump_get_buffer':
>> > reboot.c:(.text+0x100): multiple definition of `kmsg_dump_get_buffer'
>> > arch/x86/kernel/setup.o:setup.c:(.text+0x10): first defined here
>> > arch/x86/kernel/reboot.o: In function `kmsg_dump_rewind':
>> > reboot.c:(.text+0x110): multiple definition of `kmsg_dump_rewind'
>> > arch/x86/kernel/setup.o:setup.c:(.text+0x20): first defined here
>>
>> Caused by commit e2ae715d66bf ("kmsg - kmsg_dump() use iterator to
>> receive log buffer content") from the driver-core.current tree.
>
> I'm building my tree right now, and I can't seem to hit this.
>
>> This was reported a few days ago.  Why is it not fixed yet?
>
> It was reported Friday evening, on a holiday weekend for some of us, we
> are trying the best we can :)
>
>> Especially since it is in a branch that is supposedly "bug fixes"?
>
> It fixes up a reported problem, and we had 3 people test it and said it
> resolved the issue for them, no build problems reported.
>
> Randy, can I get a copy of your .config that duplicates this?

I looked at it, and did not see it, I was blind.

We just miss the "static inline" in include/linux/kmsg_dump.h. :)

Sorry for that,
Kay
