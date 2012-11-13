Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2KMKjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:39:16 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40436 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2KMKjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:39:14 -0500
MIME-Version: 1.0
In-Reply-To: <1352757066.32153.5@snotra>
References: <CAMuHMdXE0yJNivpirGgx08zqLH2086ydeOU6zswXj-+zn8OsWQ@mail.gmail.com>
	<1352757066.32153.5@snotra>
Date: Tue, 13 Nov 2012 11:39:13 +0100
X-Google-Sender-Auth: 03WikOETNFAecaWE0Xb9eTbVICs
Message-ID: <CAMuHMdVytJ6YcDb1-MAaqwgTKXDLi3tJaVW3vh9aE5smNwJR=g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Scott Wood <scottwood@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On Mon, Nov 12, 2012 at 10:51 PM, Scott Wood <scottwood@freescale.com> wrote:
> On 11/12/2012 03:02:46 PM, Geert Uytterhoeven wrote:
>> On Mon, Nov 12, 2012 at 9:58 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > JFYI, when comparing v3.7-rc5 to v3.7-rc4[3], the summaries are:
>> >   - build errors: +14/-4
>>
>> 14 regressions:
>>   + drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first
>> use in this function):  => 799:93
>
> These reports would be more useful if the actual .config were provided,
> rather than just saying "powerpc randconfig".

This can be obtained from the kissb build system.
[1] http://kisskb.ellerman.id.au/kisskb/head/5614/ (all 117 configs)

> I doubt this particular one is a regression; it looks like the dependencies

Yeah, regressions in randconfigs can be misleading.
Still, they're build failures.

> have always been too weak (patch sent) and you're just comparing different
> randomly-generated configs.

Thanks for your patch!

>> powerpc-randconfig
>>
>>   + error: relocation truncated to fit: R_PPC64_REL24 against symbol
>> `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:
>> (.text+0x1ff9eb8) => (.text+0x1ffa274), (.text+0x1ff7840)
>>
>> powerpc-allyesconfig
>
>
> It's been over 3 years since powerpc-allyesconfig built (it's just too big
> for the relocation model the kernel uses) -- how is this a regression?

It's a regression because it didn't complain about ".mcount" in the
previous run.

But I'll start stripping them from the rc-incremental reports.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
