Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0EATfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 15:35:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60507 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753683Ab0EATfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 15:35:50 -0400
Date: Sat, 1 May 2010 20:41:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console logging detour via printk
Message-ID: <20100501204131.4c7aeae4@lxorguk.ukuu.org.uk>
In-Reply-To: <1272739689.2147.156.camel@itpsd6lap>
References: <1272664980.10241.77.camel@itpsd6lap>
	<20100501120418.6fca2aad@lxorguk.ukuu.org.uk>
	<1272739689.2147.156.camel@itpsd6lap>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The distros have no problem logging complete console output into log
> files or over the network, because they simply do not do it at least for
> the initrd part of the boot process (i'd be glad, if i'm wrong). 

I'd have to double check - but its trivial to move the log if so.

> > I suspect what you actually need for such logging might be to write a
> > very simple tty driver whose write method is implemented as printk. That
> > works in the general case and doesn't require hacking up the code
> > everywhere else.
> 
> Looks to me that some kernel code is welcome:)?

I really don't see the point but if you must do it then doing it as its
own driver would at least avoid making a mess in the rest of the kernel,
at which point it becomes less of a problem

> > However given your init stuff can trivially use openpty to set up a logged
> > console I am not sure I see the point in doing this in kernel in the
> > first place.
> > 
> 
> As said above, how to bridge kernel boot start and logging daemon
> start-up without kernel help, especially when initrd is in the way? imho
> it would be too complicated.

Put the logging start up in the initrd, its just a ramdisk its not
special in any way at all.
