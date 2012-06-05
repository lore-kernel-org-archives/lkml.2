Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2FEU5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:57:33 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56420 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2FEU5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120530140444.GA10543@frolo.macqel>
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
	<20120530102226.GA28628@frolo.macqel>
	<CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
	<20120530140444.GA10543@frolo.macqel>
Date: Tue, 5 Jun 2012 22:57:29 +0200
X-Google-Sender-Auth: lTgex80yLmK_O041XXmKWjZbLds
Message-ID: <CAMuHMdW29QYN6XpBb9F3GGoJ-9frrD-00Wx=FchT9ALqW1LcPg@mail.gmail.com>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(), and strnlen_user()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>, Greg Ungerer <gerg@uclinux.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 4:04 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> On Wed, May 30, 2012 at 01:20:02PM +0200, Geert Uytterhoeven wrote:
>> On Wed, May 30, 2012 at 12:22 PM, Philippe De Muyter <phdm@macqel.be> wrote:
>> > On Tue, May 29, 2012 at 11:33:36PM +0200, Geert Uytterhoeven wrote:
>> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> >> ---
>> >> Do we also want
>> >>
>> >>     select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE && !M68000)
>> >
>> > Sorry, I did not follow what happened to unaligned accesses, but
>> > CPU32 family (at least 68340) crashes on unaligned accesses.
>>
>> We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?
>
> I have a local port here (but based on an ancient linux kernel, 2.6.2 IIRC)
>
>> But Freescale's website confirms both 68340 and 68360 are CPU32.
>>
>> arch/m68k/include/asm/unaligned.h assumes CPU32 (CONFIG_MCPU32)
>> can do unaligned accesses:
>
> That's not true.  Accessing a 16- or 32-bit word at an odd address
> with a 68340 generates an Address Error Exception.  I remember
> discovering a bug in the ppp kernel code because of that.
>
>>
>> #if defined(CONFIG_COLDFIRE) || defined(CONFIG_M68000)
>> #include <linux/unaligned/be_struct.h>
>> #include <linux/unaligned/le_byteshift.h>
>> #include <linux/unaligned/generic.h>
>>
>> #define get_unaligned   __get_unaligned_be
>> #define put_unaligned   __put_unaligned_be
>>
>> #else
>> /*
>>  * The m68k can do unaligned accesses itself.
>>  */
>> #include <linux/unaligned/access_ok.h>
>> #include <linux/unaligned/generic.h>
>>
>> #define get_unaligned   __get_unaligned_be
>> #define put_unaligned   __put_unaligned_be
>>
>> #endif
>>
>> Is this wrong?
>
> I can't tell from reading just the lines above, but I think one should add
> "|| defined(CONFIG_MCPU32)" at the end of the if condition.

Greg?

If more CPUs cannot handle unaligned accesses, I propose to add
CONFIG_CPU_HAS_NO_UNALIGNED.

> I also think that the Coldfire 5272 can do unaligned accesses, but I
> cannot test that at the moment.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
