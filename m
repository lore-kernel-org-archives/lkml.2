Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0LJA3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:29:06 -0500
Received: from kroah.org ([198.145.64.141]:57479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab0LJA3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:29:05 -0500
Date: Thu, 9 Dec 2010 16:25:05 -0800
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
Message-ID: <20101210002505.GA16352@kroah.com>
References: <20101209205820.GA6014@xanatos>
 <463402.63193.qm@web31809.mail.mud.yahoo.com>
 <20101210001155.GB11803@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101210001155.GB11803@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 04:11:55PM -0800, Sarah Sharp wrote:
> On Thu, Dec 09, 2010 at 02:54:19PM -0800, Luben Tuikov wrote:
> > --- On Thu, 12/9/10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> > > -0800, Luben Tuikov wrote:
> > > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > > ---
> > > >  The long story is that we see some host
> > > controllers misreport their
> > > >  PSA as they solved 2^v = streams, instead of
> > > 2^(v+1) = streams. Thus
> > > >  They report that they support 32 streams when in
> > > fact they support 16.
> > > >  When the device attempts to return status for
> > > stream > 15, the host
> > > >  says ACK(NumP=0), the device goes in flow
> > > control, blah, blah, this
> > > >  module parameter allows you to set a max cap on
> > > the number of streams
> > > >  the driver will ask XHCI HCD to allocate.
> > > 
> > > If this is an issue with a host then the work-around should
> > > be in the
> > > xHCI driver instead.  It should be based on the
> > > vendor/device ID of the
> > > offending host instead of being a module parameter in the
> > > UAS driver.
> > > The only people who benefit from this patch are the people
> > > "in the know"
> > > about which hosts are buggy, not normal Linux users.
> > 
> > The OS might want to limit the number of streams for reasons other
> > than a buggy HC. So this module parameter add flexibility other than
> > making a buggy HC work.
> 
> Ok, that's fine, but my comments still stand about fixing this
> particular bug in the xHCI driver, rather than in the UAS driver.

I agree.

Also, a module parameter will not work when your driver is connecting to
different xHCI devices in the same system.  Please never add module
parameters anymore, there is usually never a need for them at all.

thanks,

greg k-h
