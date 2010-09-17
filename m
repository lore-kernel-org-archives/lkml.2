Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0IQVMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:12:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:43783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0IQVMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:12:23 -0400
Date: Fri, 17 Sep 2010 14:09:15 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
Message-ID: <20100917210915.GA21781@suse.de>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m1eicw892p.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
 <20100917205705.GD2522@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917205705.GD2522@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:57:05PM +0200, Hans J. Koch wrote:
> On Fri, Sep 17, 2010 at 10:36:50PM +0200, Thomas Gleixner wrote:
> > On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> > 
> > > 
> > > register_chrdev limits uio devices to 256 minor numbers which causes
> > > problems on one system I have with 384+ uio devices.  So instead set
> > > UIO_MAX_DEVICES to the maximum number of minors and use
> > > alloc_chrdev_region to reserve the uio minors.
> > > 
> > > The final result is that the code works the same but the uio driver now
> > > supports any minor the idr allocator comes up with.
> > > 
> > > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> > 
> > One minor nit:
> > 
> > > +	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
> > > +	if (result)
> > > +		goto out;
> > 
> >   		return result;
> 
> Well, ok... Greg, can you fix this when you take the patch into your tree?

Yes I can, and will.

thanks,

greg k-h
