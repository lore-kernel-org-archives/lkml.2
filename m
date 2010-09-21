Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0IUVie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:38:34 -0400
Received: from www.tglx.de ([62.245.132.106]:36632 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IUVid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:38:33 -0400
Date: Tue, 21 Sep 2010 23:38:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
In-Reply-To: <20100921210809.GA28026@kroah.com>
Message-ID: <alpine.LFD.2.00.1009212337030.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m1eicw892p.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6> <20100921210809.GA28026@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Greg KH wrote:

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
> Wait, why?  It's the exact came code, as out does:
> 
> out:
> 	return result;
> 
> and you need that line due to the code above it.  So I say leave it.

s/goto out/return result/g

Gotos which end up in a single line "return foo;" are pretty pointless.

Thanks,

	tglx
