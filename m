Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0FVXE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:04:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab0FVXEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:04:55 -0400
Date: Tue, 22 Jun 2010 16:01:13 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
Message-ID: <20100622230113.GB18495@suse.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
 <AANLkTim4dHj_3ftAVD35DD-Cc7ZntHRi1YTRPup2wfJc@mail.gmail.com>
 <201006191432.04685.arnd@arndb.de>
 <201006192229.21971.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006192229.21971.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 10:29:21PM +0200, Arnd Bergmann wrote:
> On Saturday 19 June 2010 14:32:04 Arnd Bergmann wrote:
> > > I boot with a "console=uart,io,0x3f8" argument, so I start out using
> > > 8250_early.c. Looks like it switched to 8250.c based on seeing
> > > this:
> > > 
> > > Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > > 
> > > on the console log.
> > 
> > Good, so it's something I should be able to reproduce on a PC.
> 
> I could reproduce the problem now and bisected it down to a cleanup
> patch that can fortunately get reverted. The symptom that I saw
> is that when I open a serial port for the second time (e.g. starting
> getty and logging in), the output gets garbled, while the first one
> worked fine. This does not rely on the console code at all.
> 
> Original commit message:
>     Our code now rather closely resembles the helper, so switch to it.
> 
> Apparently, the two functions are not really doing the same,
> so revert the commit for now. This includes the addition of
> a tty_unlock()/tty_lock() pair when blocking on the wait queue.
> 
> Greg, do you want to apply this patch on top of the series, or
> do you prefer to get a replacement for the original patch, once
> we know what's wrong with it?

A replacement for the original one might be best if we can figure it
out.

Just let me know what you need me to do.

thanks,

greg k-h
