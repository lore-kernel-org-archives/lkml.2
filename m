Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2LLIvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:51:01 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:50662 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2LLIvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:51:00 -0500
Date: Wed, 12 Dec 2012 09:50:54 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-kernel@vger.kernel.org, Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 2/2] uio: do not expose inode to uio open/release hooks
Message-ID: <20121212085053.GF2642@local>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
 <1355267523-19724-3-git-send-email-b.spranger@linutronix.de>
 <20121211232032.GA24933@kroah.com>
 <20121212014221.GA2642@local>
 <20121212044648.GB7224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212044648.GB7224@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:46:48PM -0800, Greg KH wrote:
> On Wed, Dec 12, 2012 at 02:42:22AM +0100, Hans J. Koch wrote:
> > On Tue, Dec 11, 2012 at 03:20:32PM -0800, Greg KH wrote:
> > > On Wed, Dec 12, 2012 at 12:12:02AM +0100, Benedikt Spranger wrote:
> > > > The inode parameter is unused by in kernel users of UIO.
> > > 
> > > Ok.
> > > 
> > > > Also the inode parameter makes it hard to resolve the existing open(),
> > > > mmap() and close() difficulty.
> > > 
> > > I don't understand, what do you mean by this?  What is this parameter
> > > causing problems with?
> > 
> > The problem is that according to POSIX, it is guaranteed that in userspace
> > you can do
> > 
> > fd = open("/dev/uio0", ...)
> > ptr = mmap(...fd...)
> > close(fd)
> > 
> > with ptr still being valid and useable after that.
> 
> Yes, but what does that have to do with this in-kernel, internal api?

Ah, OK. You're right, the commit message is confusing.

Bene, it's enough to say we drop the inode parameter because nobody
ever needed it. I cannot see why this also helps with the other problem.

Thanks,
Hans
