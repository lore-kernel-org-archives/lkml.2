Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665Ab2DLTrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:47:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54510 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2DLTrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120412194016.GA30558@merkur.ravnborg.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
	<1332960678-11879-2-git-send-email-andi@firstfloor.org>
	<CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>
	<20120412194016.GA30558@merkur.ravnborg.org>
Date: Thu, 12 Apr 2012 21:47:19 +0200
X-Google-Sender-Auth: oaXgR1SeLGrJdxKVhEI50OPXOqE
Message-ID: <CAMuHMdXfpvprGD18_YYyctfrAk6iRJonWFGFRf9oSaH0u0zfhw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Thu, Apr 12, 2012 at 21:40, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Apr 12, 2012 at 09:08:36PM +0200, Geert Uytterhoeven wrote:
>> On Wed, Mar 28, 2012 at 20:51, Andi Kleen <andi@firstfloor.org> wrote:
>> > +ifdef CONFIG_READABLE_ASM
>> > +# Disable optimizations that make assembler listings hard to read.
>> > +# reorder blocks reorders the control in the function
>> > +# ipa clone creates specialized cloned functions
>> > +# partial inlining inlines only parts of functions
>> > +KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
>> > +                 $(call cc-option,-fno-ipa-cp-clone,) \
>> > +                 $(call cc-option,-fno-partial-inlining)
>> > +endif
>
> Could people move to this century and drop these ugly "\" line-continuations please...
> People seems to get along in C without but think they should be used in Makefiles..

Not without an additional patch for make:

Makefile:575: *** missing separator (did you mean TAB instead of 8
spaces?).  Stop.

>> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
>>
>> Somehow, "$(call cc-option,-fno-ipa-cp-clone,)" doesn't detect that my
>> toolchain (gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21))
>> doesn't support this option.

> You should try cc-diasable-warning like this:
>
> KBUILD_CFLAGS += $(call cc-disable-warning, ipa-cp-clone)

That works, thanks!
Andi, does it still work as expected for you?

> from Documentation/kbuild/makefiles.txt:
>
>    cc-disable-warning
>        cc-disable-warning checks if gcc supports a given warning and returns
>        the commandline switch to disable it. This special function is needed,
>        because gcc 4.4 and later accept any unknown -Wno-* option and only
>        warn about it if there is another warning in the source file.
>
>        Example:
>                KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
>
>        In the above example, -Wno-unused-but-set-variable will be added to
>        KBUILD_CFLAGS only if gcc really accepts it.
>
>
> The documentation refer to gcc 4.4 - but maybe the older gcc you have
> has the same behaviour.

Seems to be that case. Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
