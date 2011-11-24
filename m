Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab1KXQrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:47:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1KXQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:47:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Subject: Re: [PATCH v7 3/5] drivers/i2c/busses/i2c-at91.c: add new driver
Date: Thu, 24 Nov 2011 16:47:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>
References: <cover.1322062555.git.n.voss@weinmann.de> <201111241539.06990.arnd@arndb.de> <EF2E73589CA71846A15D0B2CDF79505D087B45007C@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B45007C@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111241647.35818.arnd@arndb.de>
X-Provags-ID: V02:K0:LKsGuMlgkk4GRzGjZb+O8FahNDX1i7ydEb+PVcMnNY/
 UPnXoGbbzMQGtanbqkFRQjieKANOH09669G0hAVTjCWIGuJR4R
 hCJnoLUXOrjLGl5WtxHUiS17ybY1Dj+Sq1UvtXzDADPZBWaXDu
 mpiEVeglg1J8aDc4WGIDOhmSjm3i5xz5p4L+B5yqBH2pcMlbih
 m+w2JpvQHTDQ4pdqNmBlEpYDYq2O/enfovhkAjgMX3k9nLAfPU
 jsXUB/r/AQB7u4ek0aWMdtG0/SvOwLPb/4QZMqgFkzVOYcaC+Y
 gI9cPi5mzTCoiAS7QYixrWgNT4C38xVFQa+Ls+CPTFX4z23Y1J
 QAFjZzmBdyi2NCbDqThs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 November 2011, Voss, Nikolaus wrote:
> > Aside from the flamewar in that thread, my impression is that in general
> > people (me certainly) prefer to have driver-local workarounds be expressed
> > in a driver specific way, not in a platform or architecture specific way
> > because that makes the driver less portable.
> 
> I guess I see your point now. So you want something like pdev.has_bugX to be
> set by mach setup and later check this flag in the driver?

Yes, that would be the idea. I would not introduce platform_data for one
driver just for this though, because we are generally moving away from
platform_data towards device tree probing.

You can do it with a match table that has two entries with different
names for the two kinds of device that you need to distinguish and
set the platform_device_id->driver_data field to '1' for the type
that needs the fixup.

> > > > #define       AT91_TWI_MMR            0x00000004
> > > > #define       AT91_TWI_IADRSZ         0x00000300
> > > > #define       AT91_TWI_IADRSZ_NO      0x00000000
> > > > #define       AT91_TWI_IADRSZ_1       0x00000100
> > > > ...
> > >
> > > I agree, but this header file was already used by the old driver and
> > > converting would add possible errors to register definitions which are
> > > not (yet) used. That's why I've left it as is and just made it a local
> > > include.
> > 
> > But you are presenting the driver as a new one, so you should be
> > prepared to get review comments like any other new code.
> > 
> > Please at least move the data into the main driver file to get rid of
> > the header file.
> 
> I didn't want to appear ignorant about this, I actually appreciate your
> comment. I just wanted to point out that there might be a reason to keep
> the old file which you weren't aware of (because I presented this as a new
> driver). So, I will move the register definitions to the main driver.

Ok, good. Moving it into the driver is really the important part anyway,
and I understand your reasoning for not wanting to modify the definitions,
it just didn't apply to the one of the two comments I made about the header.

	Arnd
