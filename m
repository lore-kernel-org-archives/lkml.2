Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab1CNT7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:59:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab1CNT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110314192445.GD20259@home.goodmis.org>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
 <4D7E095802000078000363D5@vpn.id2.novell.com> <4D7E4338.1060302@zytor.com> <20110314192445.GD20259@home.goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Mar 2011 12:58:43 -0700
Message-ID: <AANLkTim0SbUQ=snszAKRHXkCj_aTJr3GN12xTE1kuj5-@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@novell.com>,
        sedat.dilek@gmail.com, Alan Modra <amodra@bigpond.net.au>,
        Ingo Molnar <mingo@elte.hu>, "H.J. Lu" <hjl.tools@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 12:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> If it was a bug in asm, but binutils can cope with it, then it should be
> a warning. If binutils can't cope, then error.

I think this is the really fundamental issue: anybody who makes a hard
error out of something that is recoverable is a total moron.

We have that in the kernel too - I've berated people for using
BUG_ON() _much_ too eagerly. If you make a hard error out of
something, that just makes things much much harder to handle, and is
just a big inconvenience for everybody. Why do it?

In the kernel, a hard error (like BUG_ON()) tends to result in a
system that is unusable and makes logging things harder. And in
development tools, a hard error just means that you stop _everybody_,
whether the user is a developer or just a tester who can't
realistically fix it (or a developer who is not involved in that
area). And even for developers who _are_ directly involved, a hard
error stops the build, instead of just letting it continue and help
him see if there are perhaps _other_ cases that should also be fixed.

So anybody who makes something a hard error when it's not required is
just being a STUPID. It hurts everybody. Don't do it.

                             Linus
