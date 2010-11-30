Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0K3OSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:18:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0K3OSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WbEQJRBVqT20qyx4jgs87lCQz9IheJwxHtaCqWsuVFLk/lyl6vHU79YVOsv5GUEpDg
         hiwGLYQI2ej0C+GkgWPR2y+xe5M2/YMRnfDQpvYyiDubJKL+/9wstM1NhTgwN+DM0Ibu
         QubsC5fZzOf6tled73NofJDlie/565gj+4TiQ=
MIME-Version: 1.0
In-Reply-To: <201011261224.59490.arnd@arndb.de>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>
	<201011251747.48365.arnd@arndb.de>
	<C832F8F5D375BD43BFA11E82E0FE9FE0082586F430@EXDCVYMBSTM005.EQ1STM.local>
	<201011261224.59490.arnd@arndb.de>
Date: Tue, 30 Nov 2010 15:18:30 +0100
X-Google-Sender-Auth: 4bfzPKw4dRn3dFDMicGtRjqUlM0
Message-ID: <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/26 Arnd Bergmann <arnd@arndb.de>:

> * When you say that the devices are static, I hope you do not mean
>  static in the C language sense. We used to allow devices to be
>  declared as "static struct" and registered using
>  platform_device_register (or other bus specific functions). This
>  is no longer valid and we are removing the existing users, do not
>  add new ones. When creating a platform device, use
>  platform_device_register_simple or platform_device_register_resndata.

Is this part of the generic ARM runtime multi-platform kernel
and device trees shebang?

The Ux500 still isn't in that sector, it needs extensive rewriting
of arch/arm/mach-ux500 to be done first, so as to support e.g.
U8500 and U5500 with a single kernel image.

Trying to skin that cat that as part of this review is a bit too
much to ask IMO, I'd rather have the author of this driver
adapt to whatever platform data registration mechanism is
in place for the merge window. Else it needs fixing as part
of a bigger endavour to root out compile-time platform
configuration.

Yours
Linus Walleij
