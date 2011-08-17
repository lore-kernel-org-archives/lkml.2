Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab1HQJje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:39:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42682 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1HQJjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:39:31 -0400
Date: Wed, 17 Aug 2011 11:39:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans Berglund <hb@spacetec.no>, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: I2C_ELEKTOR should depend on HAS_IOPORT
Message-ID: <20110817113910.47dc819f@endymion.delvare>
In-Reply-To: <CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
References: <1312802446-19154-1-git-send-email-geert@linux-m68k.org>
	<20110816195033.014f302b@endymion.delvare>
	<CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 21:14:42 +0200, Geert Uytterhoeven wrote:
> Hi Jean,
> 
> On Tue, Aug 16, 2011 at 19:50, Jean Delvare <khali@linux-fr.org> wrote:
> > On Mon,  8 Aug 2011 13:20:46 +0200, Geert Uytterhoeven wrote:
> >> drivers/i2c/busses/i2c-elektor.c: In function ‘pcf_isa_init’:
> >> drivers/i2c/busses/i2c-elektor.c:153: error: implicit declaration of function ‘ioport_map’
> >> drivers/i2c/busses/i2c-elektor.c:153: warning: assignment makes pointer from integer without a cast
> >> drivers/i2c/busses/i2c-elektor.c: In function ‘elektor_probe’:
> >> drivers/i2c/busses/i2c-elektor.c:287: error: implicit declaration of function ‘ioport_unmap’
> >>
> >> Since commit 82ed223c264def2b15ee4bec2e8c3048092ceb5f ("iomap: make IOPORT/PCI
> >> mapping functions conditional"), ioport_map() is only available on platforms
> >> that set HAS_IOPORT.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> ---
> >>  drivers/i2c/busses/Kconfig |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> >> index 646068e..d1fc5cf 100644
> >> --- a/drivers/i2c/busses/Kconfig
> >> +++ b/drivers/i2c/busses/Kconfig
> >> @@ -789,7 +789,7 @@ config I2C_ACORN
> >>
> >>  config I2C_ELEKTOR
> >>       tristate "Elektor ISA card"
> >> -     depends on ISA && BROKEN_ON_SMP
> >> +     depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
> >>       select I2C_ALGOPCF
> >>       help
> >>         This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
> >
> > How can ISA be set if HAS_IOPORT is not? This shouldn't be allowed.
> 
> It's always been like that. With CONFIG_ISA, we have inb() and friends. But not
> ioport_map(), which was introduced more recently.

OK, fair enough. Patch applied, thanks.

-- 
Jean Delvare
