Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0CRWUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:20:32 -0400
Received: from kroah.org ([198.145.64.141]:37855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0CRWUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:20:30 -0400
Date: Thu, 18 Mar 2010 15:19:58 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alex Chiang <achiang@hp.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100318221958.GB3299@kroah.com>
References: <20100316204845.GJ8278@ldl.fc.hp.com>
 <20100309184723.GA31374@kroah.com>
 <20100316212445.GA15729@xanatos>
 <20100316214014.GA8839@kroah.com>
 <20100318213308.GA5461@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318213308.GA5461@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 02:33:08PM -0700, Sarah Sharp wrote:
> On Tue, Mar 16, 2010 at 02:40:14PM -0700, Greg KH wrote:
> > On Tue, Mar 16, 2010 at 02:24:45PM -0700, Sarah Sharp wrote:
> > > Ok, I didn't see Greg's email about dynamic debugging.  I guess you
> > > shouldn't refresh the second patch.  I'm not sure how I would go about
> > > converting the xHCI driver to dynamic debugging, as I haven't looked
> > > into it.  Is there any documentation/simple examples?
> > 
> > Yes, just use 'dev_dbg' and you are finished.
> > 
> > Or pr_debug if you want to use different logging levels with your
> > macros.
> > 
> > > Greg, does the less-verbose patch with log levels still make sense if
> > > the driver got converted over to dynamic debugging?
> > 
> > I don't know what people really want to see.  In 6 months you will
> > probably only care about "debugging on or off" as the majority of the
> > messages only help you out when developing the driver, right?
> 
> "On" or "off" doesn't really help when you're trying to debug different
> parts of the driver.  If you're trying to debug a command, messages
> about wrapping rings or enqueueing transfers doesn't really matter.

Like Roland, I recommend the tracing interface for this.

> I think the end user doesn't want to see anything from the driver unless
> something serious has gone wrong.  But those cases use xhci_warn(),
> which translates down to dev_warn(), instead of xhci_dbg().

Yes, that's fine.  But you need/want something for when a user reports a
problem, and they can't rebuild their kernel.

> > So maybe par down some of the messages, or just live with seeing them
> > all, it will be easier in the end.
> 
> Yes, I did par down the duplicate/redundant messages, but I still want
> to see very detailed messages when I think there's a hardware problem.
> 
> What if I removed the debug config option for xHCI, allowed people to
> use dynamic debugging to enable debugging for specific xHCI files, but
> also allowed them to set the log level through a debugfs file?  That way
> people could still control the variety of messages that they see, but
> they can also change the level of debugging dynamically.

Sure, that might work, but I'd recommend tracing for the most part,
that's what it is there for :)

thanks,

greg k-h
