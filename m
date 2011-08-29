Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1H2HsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:48:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35876 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1H2HsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110817113910.47dc819f@endymion.delvare>
References: <1312802446-19154-1-git-send-email-geert@linux-m68k.org>
	<20110816195033.014f302b@endymion.delvare>
	<CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
	<20110817113910.47dc819f@endymion.delvare>
Date: Mon, 29 Aug 2011 09:48:17 +0200
X-Google-Sender-Auth: DTZMqAnxAfRWal6rzns0-mP2OGo
Message-ID: <CAMuHMdVX_p4Q1E+-Q1HOjUO-Zhbsv_uji2qqGZipii=qY0hHWw@mail.gmail.com>
Subject: Re: [PATCH] i2c: I2C_ELEKTOR should depend on HAS_IOPORT
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Berglund <hb@spacetec.no>, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:39, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue, 16 Aug 2011 21:14:42 +0200, Geert Uytterhoeven wrote:
>> On Tue, Aug 16, 2011 at 19:50, Jean Delvare <khali@linux-fr.org> wrote:
>> > On Mon,  8 Aug 2011 13:20:46 +0200, Geert Uytterhoeven wrote:
>> >> drivers/i2c/busses/i2c-elektor.c: In function ‘pcf_isa_init’:
>> >> drivers/i2c/busses/i2c-elektor.c:153: error: implicit declaration of function ‘ioport_map’
>> >> drivers/i2c/busses/i2c-elektor.c:153: warning: assignment makes pointer from integer without a cast
>> >> drivers/i2c/busses/i2c-elektor.c: In function ‘elektor_probe’:
>> >> drivers/i2c/busses/i2c-elektor.c:287: error: implicit declaration of function ‘ioport_unmap’
>> >>
>> >> Since commit 82ed223c264def2b15ee4bec2e8c3048092ceb5f ("iomap: make IOPORT/PCI
>> >> mapping functions conditional"), ioport_map() is only available on platforms
>> >> that set HAS_IOPORT.
>> >>
>> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> >> ---
>> >>  drivers/i2c/busses/Kconfig |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> >> index 646068e..d1fc5cf 100644
>> >> --- a/drivers/i2c/busses/Kconfig
>> >> +++ b/drivers/i2c/busses/Kconfig
>> >> @@ -789,7 +789,7 @@ config I2C_ACORN
>> >>
>> >>  config I2C_ELEKTOR
>> >>       tristate "Elektor ISA card"
>> >> -     depends on ISA && BROKEN_ON_SMP
>> >> +     depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
>> >>       select I2C_ALGOPCF
>> >>       help
>> >>         This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
>> >
>> > How can ISA be set if HAS_IOPORT is not? This shouldn't be allowed.
>>
>> It's always been like that. With CONFIG_ISA, we have inb() and friends. But not
>> ioport_map(), which was introduced more recently.
>
> OK, fair enough. Patch applied, thanks.

Any chance it will finds its way in 3.1, since it's still breaking
m68k allmodconfig
builds.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
