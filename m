Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2HTFBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:01:25 -0400
Received: from ozlabs.org ([203.10.76.45]:60388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab2HTFBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:01:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: Fix module.c build for 32 bit
In-Reply-To: <20120814151345.GB30856@linux-mips.org>
References: <87d32us55c.fsf@rustcorp.com.au> <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com> <31154.1344872382@warthog.procyon.org.uk> <32504.1344953290@warthog.procyon.org.uk> <20120814151345.GB30856@linux-mips.org>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 20 Aug 2012 12:19:36 +0930
Message-ID: <87boi65lbz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 17:13:45 +0200, Ralf Baechle <ralf@linux-mips.org> wrote:
> Fixes build failure introduced by "Make most arch asm/module.h files use
> asm-generic/module.h" by moving all the RELA processing code to a
> separate file to be used only for RELA processing on 64-bit kernels.
> 
>   CC      arch/mips/kernel/module.o
> arch/mips/kernel/module.c:250:14: error: 'reloc_handlers_rela' defined but not 
> used [-Werror=unused-variable]
> cc1: all warnings being treated as errors
> 
> make[6]: *** [arch/mips/kernel/module.o] Error 1
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> ---
> This is bigger than Jonas' suggested patch but far less #ifdefy.
> A minimal fix would be to add __maybe_unused to the definition of
> reloc_handlers_rela but imho __maybe_unused should be avoided where
> possible.
> 
> I tested this on top of today's -next but ideally to keep bisectability
> it should be applied early in the series before CONFIG_MODULES_USE_ELF_RELA
> is introduced which would require trivial tweaking arch/mips/kernel/Makefile
> tweaking.

OK, as suggested, applied as a separate patch (with a bit of tweaking),
and then modified David's patch to flip the condition in the Makefile.

This will sit in linux-next another cycle.

Cheers,
Rusty.
