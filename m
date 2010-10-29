Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538Ab0J2QfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:35:24 -0400
Received: from www.tglx.de ([62.245.132.106]:45618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab0J2QfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:35:22 -0400
Date: Fri, 29 Oct 2010 18:34:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rabin Vincent <rabin@rab.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: handle shared irqs in handle_nested_irq()
In-Reply-To: <AANLkTim_XKe9f_Onc9jXiuq14CSk9kPbPLTFvcT9caR7@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010291833440.2692@localhost6.localdomain6>
References: <1288288718-1188-1-git-send-email-rabin@rab.in> <alpine.LFD.2.00.1010282053180.2692@localhost6.localdomain6> <AANLkTinaTTqv3r0tWDOeZR5n=nHj5LybxAPf5uvUxpRh@mail.gmail.com> <alpine.LFD.2.00.1010291725370.2692@localhost6.localdomain6>
 <AANLkTim_XKe9f_Onc9jXiuq14CSk9kPbPLTFvcT9caR7@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-95874718-1288370067=:2692"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-95874718-1288370067=:2692
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 29 Oct 2010, Rabin Vincent wrote:

> On Fri, Oct 29, 2010 at 8:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 29 Oct 2010, Rabin Vincent wrote:
> >> On Fri, Oct 29, 2010 at 12:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > On Thu, 28 Oct 2010, Rabin Vincent wrote:
> >> >> Allow shared irqs to work when nested threads are used for handling
> >> >> threaded interrupts.
> >> >
> >> > Why do we want this ? handle_nested_irq() is called from a interrupt
> >> > demultiplexer, so why would we need shared interrupts for this ?
> >>
> >> Threaded IRQ + handle_nested_irq() is used by I2C GPIO expander drivers
> >> like chained hander + generic_handle_irq() is used by on-chip GPIO
> >> drivers.  If two irq handlers are registered on an on-chip GPIO
> >> interrupt (because two devices are externally connected), it works.  If
> >> the handlers are instead registered on one of the expander's pins'
> >> interrupt, without this patch, only the handler registered first is
> >> called.
> >
> > Have the hardware dudes not yet understood that shared interrupts are
> > a horrible idea ?
> 
> Note that I haven't actually seen the multiple devices to expander GPIO
> (yet?, though I've seen the multiple devices to onchip GPIO).  It seemed
> to be something missing from the irq handling though, rather than
> something that was left out on purpose.

No, I left it out on purpose and I'd rather go w/o it unless there is
a intree user.

Thanks,

	tglx
---1463795968-95874718-1288370067=:2692--
