Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0EQO0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:26:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:56026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0EQO0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:26:53 -0400
Date: Mon, 17 May 2010 07:29:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Donald Allen <donaldcallen@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: tickless scheduling
Message-ID: <20100517072953.64257f62@infradead.org>
In-Reply-To: <AANLkTin3tcYAsXVVEdhfPG0YJRYO6gcO-gCl1rlf6XNG@mail.gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	<AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	<1273540344.3843.101.camel@localhost.localdomain>
	<AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	<AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	<1273697523.2856.3.camel@localhost.localdomain>
	<AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	<alpine.LFD.2.00.1005170123090.3368@localhost.localdomain>
	<AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
	<20100517070440.13d193aa@infradead.org>
	<AANLkTin3tcYAsXVVEdhfPG0YJRYO6gcO-gCl1rlf6XNG@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 10:11:51 -0400
Donald Allen <donaldcallen@gmail.com> wrote:

> On Mon, May 17, 2010 at 10:04 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Mon, 17 May 2010 09:44:47 -0400
> > Donald Allen <donaldcallen@gmail.com> wrote:
> >
> >> I will do the experiment suggested by Arjan van de Ven and report
> >> the results of that separately.
> 
> Just for my own information, is this correct:
> 
> I assume that tickless scheduling, rather than relying on periodic
> clock interrupts to wake up the scheduler, relies on interrupt
> handlers to somehow signal the system that the scheduler needs to run
> because they've just processed an event that has changed the state of
> the system?

well.. it relies on the hardware to signal the kernel that there's work
pending for a specific device. 

technically this is true for both tickless and without tickless.
but without tickless there's so much activity in the system that it
never really goes quiet (and in fact, some different power management
decisions may be made because of that)

> 
> If so, then it looks like using the msi-style device-specific
> interrupts isn't working reliably on this hardware? Or somehow the

that looks like a correct assumption to me.

> kernel (or a driver) is failing to handle the interrupts properly with
> msi enabled on certain hardware? I mention the latter only because of
> the report yesterday from someone else seeing the same symptoms I am
> on completely different hardware.

BIOSes breaking MSI is not entirely uncommon. Windows XP does not use
MSI for various things Linux does use MSI for, and so machines that come
with XP by default may not have this feature very well tested
unfortunately.

> 
> /Don
> 
> >
> >
> > since you're losing interrupts.. another good option to try is
> > "irqpoll"
> >
> >
> > --
> > Arjan van de Ven        Intel Open Source Technology Centre
> > For development, discussion and tips for power savings,
> > visit http://www.lesswatts.org
> >


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
