Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2JIM34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:29:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49008 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2JIM3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:29:54 -0400
Date: Tue, 9 Oct 2012 13:27:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Drasko DRASKOVIC <drasko.draskovic@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
Message-ID: <20121009122733.GD4625@n2100.arm.linux.org.uk>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com> <CACRpkdY+niVs58Ay3gVNYeQPx8T7RppBJft0Bwii_RwrT2zfdw@mail.gmail.com> <CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com> <CACRpkdb+txD9hfhs7pfnzmDuU59VXEdzJc86z=tdy2yqYBCqOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb+txD9hfhs7pfnzmDuU59VXEdzJc86z=tdy2yqYBCqOg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:00:34PM +0200, Linus Walleij wrote:
> On Fri, Oct 5, 2012 at 3:16 PM, Drasko DRASKOVIC
> <drasko.draskovic@gmail.com> wrote:
> > [Me]
> >> If I understand correctly the below more or less exports
> >> struct irq_chip to userspace,
> >> trying to hide it by instead exposing a property of the
> >> containing struct gpio_chip and it worries me.
> >
> > No, it should not.
> 
> You are exporting all of the defines from irq.h,
> IRQ_TYPE_NONE, IRQ_TYPE_EDGE_FALLING, etc
> to userspace. These are defined in <linux/irq.h> and that file
> has this comment on top:
> 
> /*
>  * Please do not include this file in generic code.  There is currently
>  * no requirement for any architecture to implement anything held
>  * within this file.
>  *
>  * Thanks. --rmk
>  */
> 
> And that comment is even only about generic *KERNEL* code,
> userspace is way, way more than that.

It is always worth remembering this simple fact:

  If you export something from the kernel to userspace, it becomes part
  of the kernel's userspace API.  Userspace APIs are more stable than
  the kernel, some suggest that the userspace API should be maintained
  for 10 years.  Are you willing to set in stone for years part of the
  kernel internal structures without putting a lot of thought into how
  you export the data?

If you haven't spent a significant amount of time thinking about how you're
going to export something - and thinking about whether it should even be
exported, then you haven't done enough to outweigh the pain of having it
exported.
