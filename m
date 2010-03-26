Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0CZRvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:51:49 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:33421 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0CZRvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:51:47 -0400
Date: Fri, 26 Mar 2010 13:51:46 -0400 (EDT)
From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
Message-ID: <80528391.1791269625906877.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <201003252311.22522.mb@bu3sch.de>
Subject: Re: gpiolib: irq functions not implemented on x86
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 5.0.19_GA_2995.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.19_GA_2995.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Michael Buesch" <mb@bu3sch.de> wrote :

> Are you sure that I am the intended recipient of this mail?
> I'm not involved in the GPIO subsystem at all.

Sorry Michael, I wrote to you as the original author for the questioned code.
So being unable to find anyone in charge of the GPIO subsystem,
I'm reiterating with the x86 team.

Regards,
Jerome

On Thursday 25 March 2010 20:36:04 Jérôme Oufella wrote:
> > Hi,
> > 
> > I wrote a gpiolib implementation for Technologic Systems TS-5500
> > boards (x86)custom GPIO lines. Some of their GPIO lines are
> > directly hooked to CPU (ElanSC520) GPIRQ lines, so they can
> > trigger IRQs.
> > 
> > However, looking at arch/x86/include/asm/gpio.h:
> > /*
> >  * Not implemented, yet.
> >  */
> > static inline int gpio_to_irq(unsigned int gpio)
> > {
> >         return -ENOSYS;
> > }
> > 
> > gpio_to_irq()/irq_to_gpio() are not defined on x86 yet.
> > 
> > Q: Is there a reason not to have it return gpiolib's __gpio_to_irq(),
> > as done for other gpiolib functions defined here ? such as:
> > -       return -ENOSYS;
> > +       return __gpio_to_irq(gpio);
> > 
> > 
> > Thanks
> > Jerome Oufella
> > 
> > 
> 
> -- 
> Greetings, Michael.
