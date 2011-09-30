Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1I3Pcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:32:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45291 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1I3Pck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110930152517.GE19053@somewhere>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
	<20110930150519.GA7980@leaf>
	<20110930152517.GE19053@somewhere>
Date: Fri, 30 Sep 2011 17:32:39 +0200
Message-ID: <CAFTL4hy68KvMb_PwE6d2vYqTZ51u8QG8L_h4SRdjS9o8_tOp5g@mail.gmail.com>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Adrian Bunk <bunk@stusta.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/30 Frederic Weisbecker <fweisbec@gmail.com>:
> On Fri, Sep 30, 2011 at 08:05:19AM -0700, Josh Triplett wrote:
>> On Fri, Sep 30, 2011 at 04:42:45PM +0300, Adrian Bunk wrote:
>> > I was just wondering why I was asked about all the debug options when I
>> > tried 3.1-rc8, and that was due to commit f505c553 (debug: Make
>> > CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options),
>> > the full commit is below.
>> >
>> > It is wrong, and the author does not seem to understand how Kconfig works.
>> >
>> > The commit message is:
>> >
>> >     Several debugging options currently default to y, such as
>> >     CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users
>> >     might want to turn those options off to save space; however,
>> >     turning them off requires turning on CONFIG_DEBUG_KERNEL to
>> >     unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
>> >     unhide debugging options, and CONFIG_EXPERT exists specifically
>> >     to unhide options potentially needed by experts and/or embedded
>> >     users, make CONFIG_EXPERT automatically imply
>> >     CONFIG_DEBUG_KERNEL.
>> >
>> >
>> > Let me point at the obvious fact that both CONFIG_DEBUG_BUGVERBOSE and
>> > CONFIG_DEBUG_RODATA do depend on DEBUG_KERNEL, and are contrary to the
>> > claim of the author of this patch never enabled with
>> > CONFIG_DEBUG_KERNEL=n. [1]
>>
>> Not true:
>>
>> ~/src/linux-2.6$ rm .config
>> ~/src/linux-2.6$ make allnoconfig
>>   HOSTCC  scripts/basic/fixdep
>>   HOSTCC  scripts/kconfig/conf.o
>>   HOSTCC  scripts/kconfig/zconf.tab.o
>>   HOSTLD  scripts/kconfig/conf
>> scripts/kconfig/conf --allnoconfig Kconfig
>> #
>> # configuration written to .config
>> #
>> ~/src/linux-2.6$ grep BUGVERBOSE .config
>> CONFIG_DEBUG_BUGVERBOSE=y
>> ~/src/linux-2.6$ grep DEBUG_KERNEL .config
>> # CONFIG_DEBUG_KERNEL is not set
>>
>> DEBUG_BUGVERBOSE does not depend on DEBUG_KERNEL; it just only shows up
>> with DEBUG_KERNEL (and EXPERT) set.  The *description* has a conditional
>> on DEBUG_KERNEL and EXPERT:
>>
>> config DEBUG_BUGVERBOSE
>>         bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
>>
>> That doesn't mean the same thing as "depends on DEBUG_KERNEL".
>
> Indeed.
>
> But for DEBUG_RODATA it is the case. That said given the issue described
> with DEBUG_BUGVERSBOSE, it makes only the changelog buggy, not the patch.
>
> Also the patch was supposed to have a broader cleanup effect:
> https://lkml.org/lkml/2011/6/6/641
>
> But we applied an earlier version by accident.
>
> All in one I think we chose a wrong way to fix the issue. It's annoying to
> have all the configs that are only visible with CONFIG_EXPERT spread all
> around in random config menu.
>
> Anything that has "if CONFIG_EXPERT" should probably be moved under the CONFIG_EXPERT
> menu so that it's visible and found right away.
>

But now I realize there are too many things all around that have "if
EXPERT". So I guess we need to continue that way :)
