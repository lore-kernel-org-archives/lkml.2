Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0FOO3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0FOO3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:29:00 -0400
Date: Tue, 15 Jun 2010 10:28:11 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 00/13] jump label v9
Message-ID: <20100615142811.GB2750@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com> <20100614.204759.226765762.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614.204759.226765762.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 08:47:59PM -0700, David Miller wrote:
> Jason, I'm really at wits end about this patch set.  To say
> that trying to test our your patches is frustrating for me
> so far would be an understatement.
> 
> Nothing you ever post builds for me, not one patch set has
> built properly.
> 
> I can also tell that you're just blindly making changes to the
> sparc bits and not trying to build test them at all:
> 
> 1) Even though you created the jump_label_t, and made it properly
>    a u32 on sparc, you left the assembler using ".xword" to
>    record the entries.
> 
> 2) The sparc "struct jump_label" still calls it's third member "name",
>    it needs to be "key" or else the build breaks.
> 
> 3) Eventhough the sparc JUMP_LABEL macro was fixed to have two args,
>    the first arg was left as "tag" instead of being renamed to "key"
>    and that name change propaged into the asm in the macro expansion.
> 
> I took care of that locally to try and test this, but then I hit the
> current major problem which is that you're using things like
> text_poke_early() unconditionally, but that is an X86-only facility
> implemented by x86's alternative mechanism.
> 
> Also, kernel/jump_label.c only gets the ERR_PTR() definitions
> indirectly on the x86 platform, it needs to include linux/err.h
> directly to make sure those things are available on every platform.
> 
> You gave me the impression a few iterations ago that you were doing
> build testing on sparc64 using cross-compilers, or that you would
> start to do so.  You're obviously not, could you please start doing so
> and let me know when you've at least build tested your jump-label
> patch series on sparc64 and at least one architecture that lacks
> jump-label support?
> 
> Thanks.

Hi David,

Yes, I've tried to help re-write the sparc bits to the current api.
However, I did not test the sparc enabled jump-label bits, b/c I need an
updated cross compiler to do so (that has jump label support). However, I
certainly did build test the patches on powerpc, which lacks jump-label support,
so I know it builds on at least one architecture that lacks jump-label support
as you've mentioned. And I did this specifically, since you requested this
testing.

I guess I was hoping we could work more collaboratively on the sparc
bits. A couple lines of code have fixed the issues that you've brought up.
Sorry, if i mislead you. I really just want to do what is best for the linux
kernel, if that's going off and figuring out how to compile a new sparc
enabled jump label compiler for sparc, I will do it. And I do agree,
that leaving text_poke_early() is my mistake. However, maybe we can
discuss this issue? For example, the reason I have it in the code is b/c
x86 determines the best no-op at run-time. Are other architectures going
to have to require this kind of functionality. Or like sparc, are we
going to be able to generally hard-code the nops on non-x86 at
compile-time?

thanks. And again I apologize for any wasted cycles that I've caused.

-Jason
 

