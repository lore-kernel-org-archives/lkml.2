Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2LMQYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:24:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2LMQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:24:24 -0500
Message-ID: <50CA0134.2090608@gmail.com>
Date: Thu, 13 Dec 2012 09:24:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com> <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com> <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com> <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
In-Reply-To: <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/12 9:03 AM, Linus Torvalds wrote:
> On Thu, Dec 13, 2012 at 6:30 AM, David Ahern <dsahern@gmail.com> wrote:
>>
>> One of the problems is that existing binaries set the exclude_guest flag
>> (https://lkml.org/lkml/2012/7/9/292).
>
> [ to zero ]
>
> Yeah. And it apparently *never* worked. So it's not a regression.

The flag works. It does have a purpose. I did not write the original 
code; I am not defending its design. It is what is. We now have a 
catastrophic problem that needs to be fixed.

> So instead, you expect everybody else - for whom things *used* to work
> - to upgrade their binary, or their scripts, or just start using an
> insane command line flag that makes no sense for them? Forcing
> non-virtualization users to use a "only trace the host" flag is crazy.
>
> Either way, somebody will be unhappy. No question about that. But our
> rule in the kernel is "no regressions".

...

> But that whole "no regressions" really is important. I can work around
> things very easily, but the "no regressions" rule really means that I
> should never *need* to work around things.

I get the regressions point. I have seen that statement from you enough 
I think you have it on a permanent copy-and-paste shortcut.

Without the kernel side restriction existing perf binaries will crash 
all running VMs. I could write the patch to completely invert the 
exclude_guest logic -- make it include_guest. That breaks all existing 
perf binaries as well - just a different syntax that gets broken. That 
regression is acceptable?

David


