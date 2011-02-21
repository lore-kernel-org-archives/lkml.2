Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1BUEhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:37:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37897 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab1BUEhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:37:20 -0500
Date: Mon, 21 Feb 2011 05:37:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH -v3] kbuild: Add extra gcc checks
Message-ID: <20110221043714.GA31194@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	torvalds@linux-foundation.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	linux-kbuild@vger.kernel.org
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
 <20110220175709.GA5178@merkur.ravnborg.org>
 <20110220193906.GC6713@liondog.tnic>
 <20110220195222.GA12915@merkur.ravnborg.org>
 <20110221022316.GA18332@liondog.tnic>
 <AANLkTimZhB8Ong=nJ_mjit+VRtb7g+TQhT9_wvojQ0-e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimZhB8Ong=nJ_mjit+VRtb7g+TQhT9_wvojQ0-e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 10:26:13PM -0500, Arnaud Lacombe wrote:

> > The idea behind this option is targeted at developers who, in the
> > process of writing their code, want to do the occasional
> >
> > make W=1 [target.o]
> >
> > and let gcc do more extensive code checking for them. Then, they
> > could eyeball the output for valid gcc warnings about various
> > bugs/discrepancies which are not reported during the normal build
> > process.
> >

[..]

> > +ifeq ("$(origin W)", "command line")
> > +  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
> > +  export KBUILD_ENABLE_EXTRA_GCC_CHECKS
> > +endif
> > +
> You never check CC is gcc. How can you assert this ?

Hmm, I somehow knew that the other compilers are going to come into the
discussion :).

> Moreover, can you certify that all the compiler supported to build
> Linux do support the set of new warnings ?

Well, as you've probably already read in the commit message, this
option is for devs only, in case they want to do a build-check whether
the couple of lines they just added to a .c file trigger new compiler
warnings. So, no, I cannot certify this and I don't have to - this is
not meant for production use anyway.

> What about icc ?

I don't know, is anyone using it to build the kernel? Even if so, icc
might have a completely different set of -W options (totally guessing
here) so you shouldn't use 'make W=1' with it.

> old gcc?

Yes, cc-option should be used in that case, I'll redo the patch.

> LLVM/clang ?

Can you even build the kernel with it?

But to make sure we're on the realistic side of things. First of all,
the purpose of this is to quickly get gcc scream out while building your
changes. Secondly, let's face it, the majority of developers, if not
all, use gcc, the kernel code is full of gcc-isms so accomodating all
the compilers to such a quick-and-dirty test option is just plain too
much. Look at it this way: it is cheaper to upgrade your dev environment
than add unnecessary and ugly code to kbuild. Even the argument with
older gcc versions cannot weigh in enough in favor of the cc-option -
simply upgrade your gcc.

Thanks.

-- 
Regards/Gruss,
    Boris.
