Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1G1CtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:49:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63708 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab1G1CtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110728111709.8303f78c9b5f2b3aa3f391b0@canb.auug.org.au>
References: <1310585610-434-1-git-send-email-geert@linux-m68k.org>
	<20110724122624.324d10dc.rdunlap@xenotime.net>
	<s5hy5zm3j5a.wl%tiwai@suse.de>
	<20110725091003.c3453b8b.rdunlap@xenotime.net>
	<20110727121320.f50b1e6b.rdunlap@xenotime.net>
	<20110728111709.8303f78c9b5f2b3aa3f391b0@canb.auug.org.au>
Date: Wed, 27 Jul 2011 22:49:07 -0400
Message-ID: <CACqU3MUK4gnafNORFadKNSB2q1f3w0AiUjsLrEJJTQLFutcW9g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc7 (sound/isa/)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Takashi Iwai <tiwai@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 27, 2011 at 9:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Randy,
>
> On Wed, 27 Jul 2011 12:13:20 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> On Mon, 25 Jul 2011 09:10:03 -0700 Randy Dunlap wrote:
>>
>> > On Mon, 25 Jul 2011 09:37:53 +0200 Takashi Iwai wrote:
>> >
>> > > At Sun, 24 Jul 2011 12:26:24 -0700,
>> > > Randy Dunlap wrote:
>> > > >
>> > > > On Wed, 13 Jul 2011 21:33:30 +0200 Geert Uytterhoeven wrote:
>> > > >
>> > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declaration of function 'snd_dma_disable':  => 544
>> > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declaration of function 'snd_dma_pointer':  => 302
>> > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declaration of function 'snd_dma_program':  => 244
>> > > > >   + src/sound/isa/es1688/es1688_lib.c: error: implicit declaration of function 'snd_dma_pointer':  => 509
>> > > > >   + src/sound/isa/es1688/es1688_lib.c: error: implicit declaration of function 'snd_dma_program':  => 417
>> > > > >   + src/sound/isa/gus/gus_dma.c: error: implicit declaration of function 'snd_dma_disable':  => 177
>> > > > >   + src/sound/isa/gus/gus_dma.c: error: implicit declaration of function 'snd_dma_program':  => 79
>> > > > >   + src/sound/isa/gus/gus_pcm.c: error: implicit declaration of function 'snd_dma_pointer':  => 619
>> > > > >   + src/sound/isa/gus/gus_pcm.c: error: implicit declaration of function 'snd_dma_program':  => 591
>> > > > >   + src/sound/isa/sb/sb16_main.c: error: implicit declaration of function 'snd_dma_pointer':  => 456
>> > > > >   + src/sound/isa/sb/sb16_main.c: error: implicit declaration of function 'snd_dma_program':  => 276
>> > > > >   + src/sound/isa/sb/sb8_main.c: error: implicit declaration of function 'snd_dma_pointer':  => 425
>> > > > >   + src/sound/isa/sb/sb8_main.c: error: implicit declaration of function 'snd_dma_program':  => 172
>> > > > >   + src/sound/isa/sscape.c: error: implicit declaration of function 'snd_dma_program':  => 481
>> > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of function 'snd_dma_disable':  => 1695
>> > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of function 'snd_dma_pointer':  => 1160
>> > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of function 'snd_dma_program':  => 1025
>> > > >
>> > > > All of these source files do #include <sound/core.h>,
>> > > > but these missing/implicit functions are conditional:
>> > > >
>> > > > #ifdef CONFIG_ISA_DMA_API
>> > > > #define DMA_MODE_NO_ENABLE      0x0100
>> > > >
>> > > > void snd_dma_program(unsigned long dma, unsigned long addr, unsigned int size, unsigned short mode);
>> > > > void snd_dma_disable(unsigned long dma);
>> > > > unsigned int snd_dma_pointer(unsigned long dma, unsigned int size);
>> > > > #endif
>> > > >
>> > > > so should these drivers all depend on ISA_DMA_API ?
>> > >
>> > > Yes, these are ISA sound cards, so they must have CONFIG_ISA and
>> > > CONFIG_ISA_DMA.  Although CONFIG_SND_SB8_DSP, CONFIG_SND_SB16_DSP
>> > > and CONFIG_SND_WSS_LIB have no direct dependency, but the drivers
>> > > selecting these are all in "if SND_ISA" in sound/isa/Kconfig.
>> >
>> > Hm, yes, they are.
>> >
>> > > > or should only pieces of each driver depend on ISA_DMA_API ?
>> > >
>> > > I wonder which configuration makes it possible.
>> > > Did you see a similar problem with randconfig?
>> >
>> > No.  This parisc allmodconfig file from linux-next builds has
>> > CONFIG_SND_ISA=y but it does not have CONFIG_ISA_DMA_API enabled.  Weird.
>> >
>> > Geert, do you know how this happens?
>> >
>> > parisc config:  http://kisskb.ellerman.id.au/kisskb/buildresult/4323458/config/
>> > from this failed build:  http://kisskb.ellerman.id.au/kisskb/buildresult/4323458/
>>
>> How is CONFIG_ISA_DMA_API enabled in parisc allmodconfig?
>> I don't see how that happens, and it's causing build errors...
>
> Sorry, but I don't understand the question.  The problam is that
> CONFIG_ISA_DMA_API is not enabled, right?  On parisc, it is just (from
> arch/parisc/Kconfig)
>
> config ISA_DMA_API
>        bool
>
> and nothing selects it.  However, I would have expected an allmodconfig
> to set it to y. Clearly I don't understan how allmodconfig works any
> more :-(
>
>From what I understand of script/kconfig/symbol.c:326, in order to be
exposed in the .config, the symbol must either:
 - be visible
 - be selected
 - have a default value

ISA_DMA_API met none of the conditions.

You clearly do not want all hidden symbols to be affected by
all{mod,yes,no}config and co., that would just create a mess.

 - Arnaud

> Michal, is my understanding correct?  Is this a bug in allmodconfig?
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
