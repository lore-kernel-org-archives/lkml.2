Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab0IUVWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:22:47 -0400
Received: from kroah.org ([198.145.64.141]:42741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab0IUVWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:22:47 -0400
Date: Tue, 21 Sep 2010 14:08:09 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
Message-ID: <20100921210809.GA28026@kroah.com>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m1eicw892p.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:36:50PM +0200, Thomas Gleixner wrote:
> On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> 
> > 
> > register_chrdev limits uio devices to 256 minor numbers which causes
> > problems on one system I have with 384+ uio devices.  So instead set
> > UIO_MAX_DEVICES to the maximum number of minors and use
> > alloc_chrdev_region to reserve the uio minors.
> > 
> > The final result is that the code works the same but the uio driver now
> > supports any minor the idr allocator comes up with.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> One minor nit:
> 
> > +	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
> > +	if (result)
> > +		goto out;
> 
>   		return result;

Wait, why?  It's the exact came code, as out does:

out:
	return result;

and you need that line due to the code above it.  So I say leave it.

thanks,

greg k-h
