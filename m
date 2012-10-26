Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482Ab2JZRW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:22:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61236 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965377Ab2JZRWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1210251028470.640@diagnostix.dwd.de>
References: <alpine.LRH.2.02.1210251028470.640@diagnostix.dwd.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 10:22:32 -0700
X-Google-Sender-Auth: Zuqvb2QAtnjnwrk_Ab7vZ569TC0
Message-ID: <CA+55aFx+nKJmtmRNXeG1AcSHD1g_6qQwTZuNreFnp0dSSun+ZA@mail.gmail.com>
Subject: Re: Enabling hardlink restrictions to the Linux VFS in 3.6 by default
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 5:13 AM, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>
> as of linux 3.6 hardlink restrictions to the Linux VFS have been enabled
> by default. This breaks the application AFD [1] of which I am the author.

Ok, we had a previous report of breakage, but that was just local
scripting. Since that was just a single user (Nick Bowler), and he was
ok with just fixing his setup, I let it go, waiting to see if anybody
else reacted.

There may well have been other users that had odd breakage, but didn't
realize what the cause was.

Regardless, clearly this does break things, and as such needs to be
undone. We do not cause regressions that people notice in the kernel.

So I've defaulted these things to off, and marked it for stable. See
commit 561ec64ae67e ("VFS: don't do protected {sym,hard}links by
default"). Either distributions can enable it with some security
setting (along with the other security things they do, like the whole
selinux thing), or we might at some future date make some config
option for "boot up in hard-*ss mode that may break things", but for
now we clearly cannot enable it by default.

I've added people from the original commit and the previous discussion
to the cc, and marked the commit for stable too.

  Thanks,
              Linus
