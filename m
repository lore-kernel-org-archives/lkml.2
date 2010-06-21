Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0FUQzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:55:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65486 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab0FUQyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p67pwuF2r3obWawzml08xw70oIR+9TAee2hWFGFRetRKt5Iovgc6s5jFdGnZi+ckpL
         Tnui9o574bJB6ftg4ZvUdYiJNRytckGxHEuUvPP+BFqvmx0gKYTyyYDfF7eLjcV2paak
         l2FING/F9BwQQ8spE84BGPo6Cknik0yFEYhN0=
MIME-Version: 1.0
In-Reply-To: <20100621164732.GA2725@oksana.dev.rtsoft.ru>
References: <AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com> 
	<20100618133212.GA5276@oksana.dev.rtsoft.ru> <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com> 
	<AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com> 
	<20100621071551.GA16109@oksana.dev.rtsoft.ru> <AANLkTiknH95loHJsQNxvCCyQbriCFWqM5LHl3wKzmdWX@mail.gmail.com> 
	<20100621073909.GA20674@oksana.dev.rtsoft.ru> <AANLkTinjhmkQafVlrtQC5yDnqIZz859_wrZqo45QOEJ2@mail.gmail.com> 
	<20100621112049.GA9273@oksana.dev.rtsoft.ru> <AANLkTinvHrjD-gwCMQIgaC4WqAbdXNstdNff2_C28byx@mail.gmail.com> 
	<20100621164732.GA2725@oksana.dev.rtsoft.ru>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Jun 2010 12:54:29 -0400
Message-ID: <AANLkTimWHFak52cs7nv2DcRnaJkgi6xSXJKCJ-N5jAwD@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80: Reworkprobing/JEDEC 
	code
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, "Song, Barry" <Barry.Song@analog.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 12:47, Anton Vorontsov wrote:
> On Mon, Jun 21, 2010 at 12:34:05PM -0400, Mike Frysinger wrote:
>> On Mon, Jun 21, 2010 at 07:20, Anton Vorontsov wrote:
>> > You can't easily change OF. It's like "let's change ACPI tables
>> > or BIOS in these PCs". Doable, but involves things like reflashing.
>> > And we usually have to support old BIOSes as well.
>> >
>> > OTOH, I see (git grep m25p arch/powerpc/boot/dts/) that in
>> > mainline kernel only MPC8569 board has a correct m25p
>> > node, and it is STMicro variant (it is JEDEC capable).
>> >
>> > As we don't really have to support out of tree code, I'd
>> > just go with this patch, assuming that we have to change
>> > device tree for boards with non-JEDEC flashes. It's
>> > effectively the same thing as platform data flag, except
>> > that it works automatically for OF platforms.
>> >
>> > diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
>> > index 81e49a9..a610ca9 100644
>> > --- a/drivers/mtd/devices/m25p80.c
>> > +++ b/drivers/mtd/devices/m25p80.c
>> > @@ -680,6 +680,16 @@ static const struct spi_device_id m25p_ids[] = {
>> >        { "m25p64",  INFO(0x202017,  0,  64 * 1024, 128, 0) },
>> >        { "m25p128", INFO(0x202018,  0, 256 * 1024,  64, 0) },
>> >
>> > +       { "m25p05-nonjedec",  INFO(0, 0,  32 * 1024,   2, 0) },
>> > +       { "m25p10-nonjedec",  INFO(0, 0,  32 * 1024,   4, 0) },
>> > +       { "m25p20-nonjedec",  INFO(0, 0,  64 * 1024,   4, 0) },
>> > +       { "m25p40-nonjedec",  INFO(0, 0,  64 * 1024,   8, 0) },
>> > +       { "m25p80-nonjedec",  INFO(0, 0,  64 * 1024,  16, 0) },
>> > +       { "m25p16-nonjedec",  INFO(0, 0,  64 * 1024,  32, 0) },
>> > +       { "m25p32-nonjedec",  INFO(0, 0,  64 * 1024,  64, 0) },
>> > +       { "m25p64-nonjedec",  INFO(0, 0,  64 * 1024, 128, 0) },
>> > +       { "m25p128-nonjedec", INFO(0, 0, 256 * 1024,  64, 0) },
>> > +
>>
>> are you picking the m25p because its flash geometry matches whatever
>> you're using, or because you have some weird variant of the m25p that
>> has JEDEC commands removed ?
>
> The latter. It's Numonyx M25Pxx flashes, see
> http://www.numonyx.com/Documents/Datasheets/M25P80.pdf
>
>   The RDID instruction is available only for parts made with 110
>   nm Technology identified with Process letter '4'.

lovely.  i guess this patch is the way to go to satisfy everyone's
requirements.  i'm also of the mindset that a mtd should not be
created if the SPI flash isnt there simply because the resources say
it might be.
-mike
