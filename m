Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0IXQOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:14:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431Ab0IXQOc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <20100924155231.GQ19804@ZenIV.linux.org.uk>
References: <20100924155231.GQ19804@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Sep 2010 09:07:33 -0700
Message-ID: <AANLkTik+1k76vGccjwQWeEWZFng61ZoodDyWbN8wvPgE@mail.gmail.com>
Subject: Re: what's papered over by set_fs(USER_DS) in amd64 signal delivery?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 8:52 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        What the hell is going on in amd64 handle_signal()?  We do
>
> #ifdef CONFIG_X86_64
>        /*
>         * This has nothing to do with segment registers,
>         * despite the name.  This magic affects uaccess.h
>         * macros' behavior.  Reset it to the normal setting.
>         */
>        set_fs(USER_DS);
> #endif

I _think_ it is historical, and probably relates to just restoring all
the user mode state at signal delivery to a known state. IOW, I think
it really does go hand-in-hand with  the whole "clear bits in the
eflags register" thing.

x86-64 has historically had some left-over crap that we already
cleaned up in 32-bit mode, for the simple reason that the original
x86-64 code was forked from an earlier base, and then hacked up
somewhat. So I think this "#ifdef CONFIG_X86_64" is just a case of
that.

But maybe we should have a WARN_ON_ONCE() to verify it, rather than
just kill it outright.

                                         Linus
