Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2BPUmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:42:54 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39272 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab2BPUmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAE6n16mCrJC=Sre+PT1H_VfSjW0MGyi0xtEcdcRvGMvvwXWzmA@mail.gmail.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
	<1329422549-16407-5-git-send-email-wad@chromium.org>
	<CAE6n16mCrJC=Sre+PT1H_VfSjW0MGyi0xtEcdcRvGMvvwXWzmA@mail.gmail.com>
Date: Thu, 16 Feb 2012 14:42:50 -0600
Message-ID: <CABqD9hZSLqn+=jr6sWwp_eJ5WsuGpH2Khoc_7aRmYt+1ZaEGoA@mail.gmail.com>
Subject: Re: [PATCH v8 5/8] seccomp: Add SECCOMP_RET_TRAP
From: Will Drewry <wad@chromium.org>
To: Markus Gutschke <markus@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 2:24 PM, Markus Gutschke <markus@chromium.org> wrote:
> SIGTRAP might not be the ideal choice of signal number, as it can make it
> very difficult to debug the program in gdb.

True enough.  In theory, we could use the lower 16-bits of the return
value to let the bpf program set a signal, but not all signals are
masked synchronous and those that are probably get gdb's attention,
just not a severely :) (ILL, SEGV, BUS, TRAP, FPE). Perhaps SIGILL is
a logically appropriate option -- or letting the api user decide from
the SYNCHRONOUS_MASK set.  I'm open to whatever makes sense, though.
(I wasn't even sure if it was kosher to add a new TRAP_SECCOMP value.)

cheers!
will
