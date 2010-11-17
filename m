Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab0KQVhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:37:47 -0500
Received: from kroah.org ([198.145.64.141]:46556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab0KQVhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:37:45 -0500
Date: Wed, 17 Nov 2010 13:25:44 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        USB list <linux-usb@vger.kernel.org>, linux-next@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20101117212544.GA10541@kroah.com>
References: <20101117042053.GB2999@kroah.com>
 <Pine.LNX.4.44L0.1011171049130.1704-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1011171049130.1704-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:56:01AM -0500, Alan Stern wrote:
> On Tue, 16 Nov 2010, Greg KH wrote:
> 
> > On Wed, Nov 17, 2010 at 01:14:53PM +1100, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> > > 
> > > drivers/media/video/tlg2300/pd-main.c: In function 'poseidon_probe':
> > > drivers/media/video/tlg2300/pd-main.c:455: error: 'struct usb_device' has no member named 'autosuspend_delay'
> > > drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
> > > drivers/net/wimax/i2400m/usb.c:517: error: 'struct usb_device' has no member named 'autosuspend_delay'
> > > 
> > > Caused by commit fcc4a01eb8661226e80632327673f67bf6a5840b ("USB: use the
> > > runtime-PM autosuspend implementation").  More grepping required ...
> > > 
> > > I have used the usb tree from next-20101116 for today.
> > 
> > Ick.  Alan, care to provide a patch?
> 
> Here it is.  I'm not sure that having this code at all is really the
> best approach.  It means the drivers will override any autosuspend
> values set by userspace when their devices are first detected.
> 
> Also there are bogus calls to device_init_wakeup(), and truly silly
> preprocessor tests of the kernel version in the staging-tree file.  
> Nevertheless, this is the minimal fix.

Don't worry about that staging driver that much, it has been massivly
cleaned up for .38, and then abandonded so the future of it is very
unlikely :)

I've applied this now, thanks.

greg k-h
