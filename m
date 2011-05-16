Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1EPRYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:24:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52802 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1EPRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:24:20 -0400
Date: Mon, 16 May 2011 19:23:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 1/6] x86-64: Clean up vdso/kernel shared variables
Message-ID: <20110516172338.GC22383@aftab>
References: <cover.1305560561.git.luto@mit.edu>
 <5062fb3d104744b00b45afec76bf78e504785370.1305560561.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5062fb3d104744b00b45afec76bf78e504785370.1305560561.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:00:58PM -0400, Andy Lutomirski wrote:
> Variables that are shared between the vdso and the kernel are
> currently a bit of a mess.  They are each defined with their own
> magic, they are accessed differently in the kernel, the vsyscall page,
> and the vdso, and one of them (vsyscall_clock) doesn't even really
> exist.
> 
> This changes them all to use a common mechanism.  All of them are
> delcared in vvar.h with a fixed address (validated by the linker
> script).  In the kernel (as before), they look like ordinary
> read-write variables.  In the vsyscall page and the vdso, they are
> accessed through a new macro VVAR, which gives read-only access.
> 
> The vdso is now loaded verbatim into memory without any fixups.  As a
> side bonus, access from the vdso is faster because a level of
> indirection is removed.
> 
> While we're at it, pack jiffies and vgetcpu_mode into the same
> cacheline.

How about

Signed-off-by:...

or you don't wanna? :)

> ---
>  arch/x86/include/asm/vdso.h     |   14 ----------
>  arch/x86/include/asm/vgtod.h    |    2 -
>  arch/x86/include/asm/vsyscall.h |   12 +-------
>  arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/time.c          |    2 +-
>  arch/x86/kernel/tsc.c           |    4 +-
>  arch/x86/kernel/vmlinux.lds.S   |   34 ++++++++-----------------
>  arch/x86/kernel/vsyscall_64.c   |   46 +++++++++++++++-------------------
>  arch/x86/vdso/Makefile          |    2 +-
>  arch/x86/vdso/vclock_gettime.c  |    3 +-
>  arch/x86/vdso/vdso.lds.S        |    7 -----
>  arch/x86/vdso/vextern.h         |   16 ------------
>  arch/x86/vdso/vgetcpu.c         |    3 +-
>  arch/x86/vdso/vma.c             |   27 --------------------
>  arch/x86/vdso/vvar.c            |   12 ---------
>  15 files changed, 91 insertions(+), 145 deletions(-)
>  create mode 100644 arch/x86/include/asm/vvar.h
>  delete mode 100644 arch/x86/vdso/vextern.h
>  delete mode 100644 arch/x86/vdso/vvar.c
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
