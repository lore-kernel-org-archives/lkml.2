Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0JNTCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:02:25 -0400
Received: from kroah.org ([198.145.64.141]:51151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0JNTCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:02:23 -0400
Date: Thu, 14 Oct 2010 11:45:11 -0700
From: Greg KH <greg@kroah.com>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Jason Wang <jason77.wang@gmail.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted
 condition.
Message-ID: <20101014184511.GA17096@kroah.com>
References: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
 <20101013062605.GB4393@suse.de>
 <AANLkTimc-ETu4zrny=kmVRq8jnh2CDiVSqE-EXde4ioS@mail.gmail.com>
 <1286969205.6082.700.camel@hammer.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286969205.6082.700.camel@hammer.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 01:26:45PM +0200, Stanislav Brabec wrote:
> On Wed, 13 Oct 2010 15:38:13 +0900, MyungJoo Ham wrote:
> > On Wed, Oct 13, 2010 at 3:26 PM, Greg KH <gregkh@suse.de> wrote:
> > > On Wed, Oct 13, 2010 at 02:58:06PM +0900, MyungJoo Ham wrote:
> 
> > > Is this a regression?  If so, from what working kernel?  Or has this
> > > always been this way?
> > 
> > I don't think this is a regression to the previous version. Logically,
> > it's matching the console_stop()-console_start() pair.
> 
> This disparity appeared deliberately in 4547be78. If you need
> no_console_suspend and the hardware lets the device in an undefined
> state after resume (i. e. PXA270), you need to call subset of the
> resume, even if the suspend counterpart was not called. Yes, I can
> imagine that it may be a source of problems.
> 
> Did you try the latest patches from Jason Wang from linux-serial list?
> 
> > Such hang in serial and its mitigation is observed in 2.6.36 at
> > arch/arm/mach-s5pv310 machines. In these machines, it hanged with
> > console_suspend_enabled == 0 every time.
> 
> It seems that support for no_console_suspend for all devices is becoming
> more complicated. I guess that a new driver calls (maybe "save_state"
> and "resume_state") or support for no_console_suspend directly in
> drivers may be useful.

Ok, so I'm guessing that this patch is not to be applied then, correct?

thanks,

greg k-h
