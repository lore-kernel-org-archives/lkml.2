Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0HaKff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:35:35 -0400
Received: from www.tglx.de ([62.245.132.106]:42924 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab0HaKfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:35:34 -0400
Date: Tue, 31 Aug 2010 12:35:25 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Armin Steinhoff <armin@steinhoff.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UIO and Fedora 13  (kernel 33.6)
Message-ID: <20100831103523.GA2598@local>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
 <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com>
 <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com>
 <4C7B8CA6.4010504@steinhoff.de>
 <20100830162435.GB2566@local>
 <4C7CA7E4.8010005@steinhoff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7CA7E4.8010005@steinhoff.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 08:57:40AM +0200, Armin Steinhoff wrote:
>  Hans J. Koch wrote:
> >On Mon, Aug 30, 2010 at 12:49:10PM +0200, Armin Steinhoff wrote:
> >>  Hi,
> >>
> >>I'm writing an UIO driver for a plain PC/104 board (ISA bus).
> >>After insmod<my_driver_mod>  I don't see an entry of uio0 in /dev
> >>and also no entries in /sys/class. There are no error messages at
> >>module load.
> >Are you sure your probe() function is called?
>   That's the case.

OK.

> 
> >  After a successfull
> >uio_register_device() there is both a /dev/uioX and a directory
> >/sys/class/uio/uioX/.
>   Seems not be possible after a kernel ooops ...

You get an oops? What does it say?

> >>The same happens after loading the module uio.ko and uio_pdrv.ko ...
> >>no entries at all, no error messages.
> >>uio_pdrv needs platform data set up somewhere, did you do that?
> >>See docs in Documentation/DocBook/ for more details.
> 
>   uio_pdrv.ko was provided unmodified and precompiles by the Fedora
> distro.

That doesn't make sense. uio_pdrv/uio_pdrv_genirq both need some help
from a board support file/driver to work.

>   This example seems more or less incomplete ... it seems also the
> case with the uio_pdrv_genirq example

Yes, of course. It doesn't make sense for distros to ship these modules.
Both are useful only for developers who build there own kernels and add
the data or irq handler needed by these drivers.

> 
>   However, it seems so I have to go back 2 steps and restart after
> reading  more details of the concept of platform devices ...

What you did was in general the right thing. Find the reason for that oops
and fix it.

Thanks,
Hans
