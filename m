Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2LBTg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:36:29 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39529 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2LBTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121202192733.GA19824@gmail.com>
References: <20121201111609.GA18679@gmail.com> <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
 <20121201214438.GA6544@gmail.com> <1354436468.7048.35.camel@marge.simpson.net>
 <20121202192733.GA19824@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 2 Dec 2012 11:36:06 -0800
X-Google-Sender-Auth: uStyaVUGFgMMsXPzq15IoT2pzp0
Message-ID: <CA+55aFxcoLuVcrxmRQ8E2d6hXQZLrg8_rzmdSL2Qn3w8VthfSg@mail.gmail.com>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 11:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Mike Galbraith <efault@gmx.de> wrote:
>
>> On Sat, 2012-12-01 at 22:44 +0100, Ingo Molnar wrote:
>>
>> > Should we use some other file for that - or no file at all and
>> > just emit a bootup printk for kernel hackers with a short
>> > attention span?
>>
>> Or, whack the file and don't bother with a printk either.  If
>> it's in your config, and your command line doesn't contain
>> noautogroup, it's on, so the info is already present (until
>> buffer gets full).  That makes for even fewer lines dedicated
>> to dinky sideline feature.
>>
>> Or (as previously mentioned) just depreciate (or rip out) the
>> whole thing since systemd is propagating everywhere anyway,
>> and offers the same functionality.
>>
>> For 3.7, a revert of 800d4d30c8f2 would prevent the explosion
>> when folks play with the now non-functional on/off switch
>> (task groups are required to _always_ exist, that commit
>> busted the autogroup assumption), so is perhaps a viable
>> quickfix until autogroups fate is decided?
>
> Linus, which one would be your preference? I'm fine with the
> first and third options - #2 that rips it all out looks like
> a sad removal of an otherwise useful feature.

I suspect #3 is the best option right now - just revert 800d4d30c8f2.

Willing to write a changelog with the pointer to the actual oops that
happens due to this issue?

               Linus
