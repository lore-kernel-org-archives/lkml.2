Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab1AaWyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:54:11 -0500
Received: from kroah.org ([198.145.64.141]:49411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1AaWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:54:09 -0500
Date: Mon, 31 Jan 2011 14:50:15 -0800
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/7] sysdev: Do not register with sysdev when erroring
 on add
Message-ID: <20110131225015.GA18474@kroah.com>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
 <1295882943-11184-2-git-send-email-bp@amd64.org>
 <20110131221659.GA14918@kroah.com>
 <20110131223319.GA3839@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131223319.GA3839@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:33:19PM +0100, Borislav Petkov wrote:
> On Mon, Jan 31, 2011 at 05:16:59PM -0500, Greg KH wrote:
> > On Mon, Jan 24, 2011 at 04:28:57PM +0100, Borislav Petkov wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > When encountering an error while executing the driver's ->add method, we
> > > should cancel registration and unwind what we've regged so far. The low
> > > level ->add methods do return proper error codes but those aren't looked
> > > at in sysdev_driver_register(). Fix that by sharing the unregistering
> > > code.
> > 
> > Have you actually hit this before?  If so, where?
> 
> Sorta. I want to be paranoid when loading the microcode image file and
> in patch 3/7 (http://marc.info/?l=linux-kernel&m=129588287409770) I
> propagate the error in case loading the microcode fails. If we don't
> cleanup here, the driver remains loaded and takes up resources. And if
> you load it again, you get a sysfs warning about duplicated entries.

Ok, it's good to clean up properly, but I was wondering if this was a
real problem that people saw "in the wild" or not.

> > > Also, fixup warning messages formatting while at it.
> > 
> > Please, no, one patch per thing.  Please break this up into two
> > different patches.
> 
> Yes, will do.
> 
> > And, in the future, let me know that you need this for other work.
> 
> Will do.
> 
> > Actually, why did you send this to Ingo in your pull request?  What does
> > your microcode patches need from this patch?  It should go through my
> > tree, especially as there is other sysdev work happening at the moment.
> 
> Sorry about that, I did not mean to bypass/offend you in any way.
> 
> > so, no, please don't send this on to anyone else right now.
> 
> Do you need the patches rediffed against a some tree of yours?

Just resend the two patches to me against linux-next and all should be
good.

thanks,

greg k-h
