Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591Ab2DLTkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:40:20 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:16161 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762551Ab2DLTkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:40:18 -0400
Date: Thu, 12 Apr 2012 21:40:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
Message-ID: <20120412194016.GA30558@merkur.ravnborg.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org> <1332960678-11879-2-git-send-email-andi@firstfloor.org> <CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 09:08:36PM +0200, Geert Uytterhoeven wrote:
> Hi Andi,
> 
> On Wed, Mar 28, 2012 at 20:51, Andi Kleen <andi@firstfloor.org> wrote:
> > +ifdef CONFIG_READABLE_ASM
> > +# Disable optimizations that make assembler listings hard to read.
> > +# reorder blocks reorders the control in the function
> > +# ipa clone creates specialized cloned functions
> > +# partial inlining inlines only parts of functions
> > +KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
> > +                 $(call cc-option,-fno-ipa-cp-clone,) \
> > +                 $(call cc-option,-fno-partial-inlining)
> > +endif

Could people move to this century and drop these ugly "\" line-continuations please...
People seems to get along in C without but think they should be used in Makefiles..

 
> This (now in linux-next) causes m68k/allmodconfig to fail for me:
> 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      kernel/bounds.s
> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
> 
> Somehow, "$(call cc-option,-fno-ipa-cp-clone,)" doesn't detect that my
> toolchain (gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21))
> doesn't support this option.
> 
> I tried playing with the trailing comma (why do the first 2 tests have it,
> and the 3rd one doesn't?), but that didn't make a difference.
The trailing comma does not have any affect - it is only ugly and should be dropped.
You should try cc-diasable-warning like this:

KBUILD_CFLAGS += $(call cc-disable-warning, ipa-cp-clone)

from Documentation/kbuild/makefiles.txt:

    cc-disable-warning
        cc-disable-warning checks if gcc supports a given warning and returns
        the commandline switch to disable it. This special function is needed,
        because gcc 4.4 and later accept any unknown -Wno-* option and only
        warn about it if there is another warning in the source file.

        Example:
                KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)

        In the above example, -Wno-unused-but-set-variable will be added to
        KBUILD_CFLAGS only if gcc really accepts it.


The documentation refer to gcc 4.4 - but maybe the older gcc you have
has the same behaviour.

		Sam
