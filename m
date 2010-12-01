Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0LABCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:02:36 -0500
Received: from kroah.org ([198.145.64.141]:59759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0LABCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:02:34 -0500
Date: Tue, 30 Nov 2010 17:00:11 -0800
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Greg KH <gregkh@suse.de>,
        Scott Wood <scottwood@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101201010011.GB31571@kroah.com>
References: <1290594227.4446.12.camel@concordia>
 <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
 <20101124182353.GA10589@suse.de>
 <1290638647.14502.10.camel@concordia>
 <20101129214439.GA9830@kroah.com>
 <4CF42053.8060801@freescale.com>
 <20101129223030.GA14663@kroah.com>
 <4CF42B02.1030009@freescale.com>
 <20101130032915.GA13386@kroah.com>
 <4CF551A0.7030200@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF551A0.7030200@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 01:33:52PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> >>> > > When this function is called, userspace had better know exactly what is
> >>> > > going on as it can get confused due to the lack of uevents happening.
> >> > 
> >> > Thanks for the explanation, but I'm just concerned that you'll add a comment
> >> > that says, "don't call this function".  A quick grep will show that there are
> >> > users of this function, and we'll have this exact conversation all over again.
> > Care to turn the above into a patch?  I'll be glad to apply that as well
> 
> One question: why are uevents not happening?

What uevent would describe this?  Userspace asked for the rename to
happen, so it better be aware that it did.

We don't want to do a "remove" and then "add" sequence of events, that
would confuse everyone.

thanks,

greg k-h
