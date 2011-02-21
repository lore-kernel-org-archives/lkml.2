Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1BUIgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:36:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1BUIgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:36:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Linn <John.Linn@xilinx.com>
Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Date: Mon, 21 Feb 2011 09:36:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <201102202237.47327.arnd@arndb.de> <c170bbf2-ac0a-4c55-b2a7-0215c7a79635@VA3EHSMHS032.ehs.local>
In-Reply-To: <c170bbf2-ac0a-4c55-b2a7-0215c7a79635@VA3EHSMHS032.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102210936.42098.arnd@arndb.de>
X-Provags-ID: V02:K0:8IOS5Gw1iu8MZ43qOgXuj+/PORtL4fUMQnjAwwEzdRI
 JV5rqX73SqgEJdBwtyi77x/jhj2XA013zh4P4R3+e4+/+tjCri
 R2yA8ZoTYoRWMidJKFmUHvHuaDZ8Pk2klfekZo6jz2S5hjIud1
 KTwkVZTIMNkwZLJIXOuLXMgeSwACDhkY9MjDlZRxsQhD1JYqDc
 ZI8+R4Vr11Y57Tz/3AklA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011, John Linn wrote:
> > > diff --git a/arch/arm/mach-xilinx/include/mach/timex.h
> > b/arch/arm/mach-xilinx/include/mach/timex.h
> > > new file mode 100644
> > > index 0000000..4ebc0a6
> > > --- /dev/null
> > > +++ b/arch/arm/mach-xilinx/include/mach/timex.h
> > > +#ifndef __MACH_TIMEX_H__
> > > +#define __MACH_TIMEX_H__
> > > +
> > > +#define PERIPHERAL_CLOCK_RATE  2500000
> > > +
> > > +#define CLOCK_TICK_RATE        (PERIPHERAL_CLOCK_RATE / 32)
> > > +
> > > +#endif
> > 
> > I thought we were at the point where CLOCK_TICK_RATE is no longer
> used.
> 
> The timer code in these patches is using it, no other comments on it so
> far.
> 
> > Did the patches not make it in yet?
> > 
> 
> I haven't heard they made them in yet, just waiting and hoping for an
> ack.

I meant the patches removing CLOCK_TICK_RATE from common code, not your
patches, sorry for being vague.

It would be better if you could avoid introducing new uses of
CLOCK_TICK_RATE, because that will have to be removed before we can 
move to a real multi-platform kernel. For instance, you can put
PERIPHERAL_CLOCK_RATE in a hardware specific header and put a bogus
definition for CLOCK_TICK_RATE into timex.h

	Arnd
