Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0K3PWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:22:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0K3PWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:22:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Date: Tue, 30 Nov 2010 16:21:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011261224.59490.arnd@arndb.de> <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com>
In-Reply-To: <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011301621.48140.arnd@arndb.de>
X-Provags-ID: V02:K0:RhJGaBtlJsiSiHNy0EMMxLdPx39fg2ppRxZKxsKXgt+
 tL3wF/obuv5GD8bQJ0H5L1qw0agb1U80ZWZrQp19mFTIYKIbFt
 sVJhxLjpDii31E9rFg1/4UckSba5a97DnIYhci1md3Fkf6BsSY
 QEMKA2e5YV4xCI/FfosjWhDxWx4prkxrQRsRGT7RLG5aMrpu/M
 IHjOv8gtVyuEeCMegUDlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 November 2010, Linus Walleij wrote:
> 2010/11/26 Arnd Bergmann <arnd@arndb.de>:
> 
> > * When you say that the devices are static, I hope you do not mean
> >  static in the C language sense. We used to allow devices to be
> >  declared as "static struct" and registered using
> >  platform_device_register (or other bus specific functions). This
> >  is no longer valid and we are removing the existing users, do not
> >  add new ones. When creating a platform device, use
> >  platform_device_register_simple or platform_device_register_resndata.
> 
> Is this part of the generic ARM runtime multi-platform kernel
> and device trees shebang?
> 
> The Ux500 still isn't in that sector, it needs extensive rewriting
> of arch/arm/mach-ux500 to be done first, so as to support e.g.
> U8500 and U5500 with a single kernel image.
> 
> Trying to skin that cat that as part of this review is a bit too
> much to ask IMO, I'd rather have the author of this driver
> adapt to whatever platform data registration mechanism is
> in place for the merge window. Else it needs fixing as part
> of a bigger endavour to root out compile-time platform
> configuration.

The 'no static devices' rule is something that Greg brought up
at the embedded developer session during PlumbersConf this year,
I wasn't aware of the problem before that either.

It is not related to the multi-platform kernel work and it's
not ARM specific.

Maybe Greg can give a short explanation of the impact of this.
AFAIR, static device definitions still work, but there are
plans to remove that capability in the future.

	Arnd
