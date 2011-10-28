Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1J1Hw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:52:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33540 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1J1Hwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <20111028070336.GF12995@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	<20111027193448.GA3514@merkur.ravnborg.org>
	<20111028070336.GF12995@elte.hu>
Date: Fri, 28 Oct 2011 09:52:53 +0200
X-Google-Sender-Auth: 3pB1K4JBbmSAllVzmik_FKKk3h8
Message-ID: <CAMuHMdUSyNcbmmXjFqSVQmsSqGS5xKFt4DSnskkg80UyWoJjLQ@mail.gmail.com>
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 09:03, Ingo Molnar <mingo@elte.hu> wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
>> The kvmconfig is an x86 specific thing - so it does not belong
>> in the scripts/kconfig/Makefile
>>
>> The *config namespace is general config targets.
>>
>> Suggestion:
>> Move the implmentation to arch/x86/Makefile and name the target
>> something that does not match the *config pattern.
>>
>> Suggestion:
>>
>>    make kvmbootable
>>
>> To tell that this convert the current config to a kvmbootable config.
>>
>> And then add the target to the x86 specific help too.
>
> KVM itself is not x86 specific (although this patch obviously is), so
> we'd like to keep at least the naming non-x86.
>
> Furthermore, the functionality generally fits into the pattern that
> 'oldconfig' does: it changes an existing config - so having 'config'
> in the name somewhere makes quite a bit of sense. If i didn't know
> what 'kvmbootable' does i couldnt guess that it touches the .config -
> while the *config pattern makes that patently obvious.
>
> Could we set aside some sort of name for such subsystem specific
> purposes and be done with it? Could we reuse the 'defconfig'
> naming perhaps and make it richer:
>
>        make defconfig kvm
>
> or:
>
>        make defconfig-kvm
>
> ? It would be very obvious at a glance what it does.

This fits in the generic "I have a .config and I want to enable an additional
option" functionality:

make oldconfig CONFIG_KVMTOOL_TEST_ENABLE=y

Don't we already have that support? I seem to remember it flying by.
Or was it just a proposal that never got implemented?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
