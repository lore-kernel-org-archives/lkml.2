Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab0JIABJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:01:09 -0400
Received: from kroah.org ([198.145.64.141]:36157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759925Ab0JIABH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:01:07 -0400
Date: Fri, 8 Oct 2010 17:00:46 -0700
From: Greg KH <greg@kroah.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009000046.GA30616@kroah.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <20101007192245.GC26435@n2100.arm.linux.org.uk>
 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
 <20101008175308.GA10975@n2100.arm.linux.org.uk>
 <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
 <20101008230451.GB10975@n2100.arm.linux.org.uk>
 <20101008232539.GA28697@kroah.com>
 <20101008234448.GD10975@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008234448.GD10975@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 12:44:48AM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 08, 2010 at 04:25:39PM -0700, Greg KH wrote:
> > I doubt that people even noticed that this was a problem.
> 
> So what you're telling me is that ARM SoC people don't read the
> ARM kernel mailing list?  I might as well stop posting patches
> if no one's paying attention then! :-P
> 
> Reality is that it was discussed, and I did propose solutions at
> the time.

Heh, fair enough

> > Unless you throw a run-time warning at them, or even better, break the
> > build of their drivers, they will not notice.
> > 
> > Also, how can we fix this in a driver, what is the proper steps to do
> > so?
> 
> On April 23rd:
> | I think a viable safe solution is to set aside some RAM at boot (which
> | the kernel doesn't manage at all) and then use ioremap on that; that
> | approach will still work with this patch in place.
> 
> On April 30th when discussing the omapfb driver:
> | There's really one option for this - in the machine's fixup handler, you
> | can walk the meminfo array and kick out some memory from that.  This will
> | prevent the kernel mapping that memory and make pfn_valid() fail for that
> | memory range.  Another advantage of this is that it won't break when we
> | switch to LMB.

Ah, but no drivers have been fixed in any of these ways yet?

> So, as I say, there's been six months.  It was discussed.  But still
> we find that the drivers haven't been touched and now we're complaining
> that drivers are breaking.
> 
> If it hadn't been discussed, if solutions hadn't been proposed, then
> yes, it would be right to revert it out-right.  But that's not what
> happened.
> 
> If we have to have another three months (or so), this time with a warning,
> then so be it, but let's make it plainly clear that it _will_ _definitely_
> be changing, and that drivers _will_ break unless they are fixed.
> 
> Unfortunately, what I fear is that nothing will happen because people
> want the ioremap-on-system-RAM to just work, and then we'll hit this
> exact same issue again in three months time.

But you can't expect that you make this change, and not fix up the
drivers, and people would be happy, right?  The rule for API changes
like this, or anything, is that the person making the change fixes the
other drivers, and that seems to be the issue here.

Any pointers to patches where people have fixed up the drivers?

thanks,

greg k-h
