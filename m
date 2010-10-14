Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0JNUL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:11:29 -0400
Received: from kroah.org ([198.145.64.141]:35328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab0JNULS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:11:18 -0400
Date: Thu, 14 Oct 2010 13:05:26 -0700
From: Greg KH <greg@kroah.com>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Jason Wang <jason77.wang@gmail.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted
 condition.
Message-ID: <20101014200526.GB30831@kroah.com>
References: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
 <20101013062605.GB4393@suse.de>
 <AANLkTimc-ETu4zrny=kmVRq8jnh2CDiVSqE-EXde4ioS@mail.gmail.com>
 <1286969205.6082.700.camel@hammer.site>
 <20101014184511.GA17096@kroah.com>
 <1287085557.10610.18.camel@utx.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287085557.10610.18.camel@utx.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 09:45:57PM +0200, Stanislav Brabec wrote:
> Greg KH wrote: 
> > > This disparity appeared deliberately in 4547be78. If you need
> > > no_console_suspend and the hardware lets the device in an undefined
> > > state after resume (i. e. PXA270), you need to call subset of the
> > > resume, even if the suspend counterpart was not called. Yes, I can
> > > imagine that it may be a source of problems.
>  
> > > It seems that support for no_console_suspend for all devices is becoming
> > > more complicated. I guess that a new driver calls (maybe "save_state"
> > > and "resume_state") or support for no_console_suspend directly in
> > > drivers may be useful.
> > 
> > Ok, so I'm guessing that this patch is not to be applied then, correct?
> 
> I just compared it with Jason Wang's patches. MyungJoo Ham's patch is
> exactly equal to the PATCH 1/2. So it already has my ACK and it is
> pending as:
> 
> serial-core: skip call set_termios/console_start when no_console_suspend

Ah, ok, thanks for confirming this, no need for me to do anything else
then, I like it :)

thanks,

greg k-h
