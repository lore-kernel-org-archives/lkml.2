Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab1DLTjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:39:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46563 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756787Ab1DLTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:39:44 -0400
Date: Tue, 12 Apr 2011 21:39:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: zaurus-devel@www.linuxtogo.org, kernel list <linux-kernel@vger.kernel.org>
Subject: 8250 vs pxa_serial (was Re: pxa27x/spitz: serials in recent
 kernels)
Message-ID: <20110412193943.GA30089@elf.ucw.cz>
References: <20110315192111.GA2983@ucw.cz>
 <AANLkTikJD3+HSoHbq2BxAyYbtGik8QizuRv=rkPEtJXN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikJD3+HSoHbq2BxAyYbtGik8QizuRv=rkPEtJXN@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I cculd not get serial port to work in recent kernels (2.6.35 was
> > oldest I tried). I know they are little used but still very useful for
> > debugging.
> >
> > Is there some special config that needs to be done?
> >                                                        Pavel
> 
> I have output on ttyS0 using the Sharp cable, never had issues.
> Remember that bootloader is 9600n8 while kernels are usually 115200n8.

Ok, I know what is going on. I need both PXA_SERIAL and 8250... and
these two don't go well together.

I tried:

CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=1
CONFIG_SERIAL_8250_RUNTIME_UARTS=0
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_PXA=y
CONFIG_SERIAL_PXA_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y

(BTW should 8250_RUNTIME_UARTS be called "boottime uarts"? That's what
help says).

...but no luck. As soon as I enable 8250, pxa serials stop working
:-(.
										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
