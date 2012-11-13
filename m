Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2KMKN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:13:28 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33217 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2KMKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:13:25 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <201211071421.39523.arnd@arndb.de>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
	<1352281674-2186-15-git-send-email-vgupta@synopsys.com>
	<201211071421.39523.arnd@arndb.de>
Date: Tue, 13 Nov 2012 12:13:23 +0200
Message-ID: <CAOtvUMcc-7mBxYWEe7oypri7wxf58R8cph7EpdLYR_fLHO6eTg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 4:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 07 November 2012, Vineet Gupta wrote:
>> + * Being uClibc based we need some of the deprecated syscalls:
>> + * -Not emulated by uClibc at all
>> + *     unlink, mkdir,... (needed by Busybox, LTP etc)
>> + *     times (needed by LTP pan test harness)
>> + * -Not emulated efficiently
>> + *     select: emulated using pselect (but extra code to chk usec > 1sec)
>> + *
> ...
> I'm pretty sure that this has been solved before, best get in contact with
> the maintainers of the openrisc/c6x/hexagon platforms, that probably all
> use uClibc without needing these.
>
> You have to remove the legacy calls here.

So, I completely agree about not adding more deprecated system call or
ABIs (thinking about the ptrace regset issues in another patch in the
same patchset), but on the other hand I have to wonder if having a
port in the tree that doesn't have a working C library or a debugger
makes sense.

I mean, it is not quite the same thing as saying: "well, users of the
old versions of the user tools will need to maintain out of tree
patches". That makes sense - it puts the burden of maintenance on
people clinging to new versions when newer one exists, but this is not
what is happening with Arc. Right now, there are no working version of
the tools for Arc, so everyone will need to use the out of tree
patches.

I wonder what is worse - having an in tree port that no one (can) use
or adding some deprecated crap (sorry...), clearly marked for deletion
the minute a version of the relevant user tools exists that can be
used with the new mechanisms?

Just my 2c as an Arc kernel port user,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
