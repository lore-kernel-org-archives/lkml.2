Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab1ESSTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:19:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:47184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928Ab1ESSTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:19:06 -0400
Date: Thu, 19 May 2011 11:18:14 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [57/71] block: rescan partitions on invalidated devices on
 -ENOMEDIA too
Message-ID: <20110519181814.GA17816@suse.de>
References: <20110519180626.GA16555@kroah.com>
 <20110519180559.722522150@clark.kroah.org>
 <BANLkTi=dKXo=TeTU7a--r3YCxrptNU3VVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=dKXo=TeTU7a--r3YCxrptNU3VVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:12:44PM +0200, Tejun Heo wrote:
> Hello, Greg.
> 
> On Thu, May 19, 2011 at 8:05 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Tejun Heo <tj@kernel.org>
> >
> > commit 02e352287a40bd456eb78df705bf888bc3161d3f upstream.
> >
> > __blkdev_get() doesn't rescan partitions if disk->fops->open() fails,
> > which leads to ghost partition devices lingering after medimum removal
> > is known to both the kernel and userland.  The behavior also creates a
> > subtle inconsistency where O_NONBLOCK open, which doesn't fail even if
> > there's no medium, clears the ghots partitions, which is exploited to
> > work around the problem from userland.
> >
> > Fix it by updating __blkdev_get() to issue partition rescan after
> > -ENOMEDIA too.
> >
> > This was reported in the following bz.
> >
> >  https://bugzilla.kernel.org/show_bug.cgi?id=13029
> >
> > Stable: 2.6.38
> >
> 
> Can you please hold this for a while?  It causes an extra warning
> message to be printed during device detection.  It isn't harmful but
> still.  I'll soon send a patch to resolve the issue and it would be
> better for them to go together.

Sure, I've dropped this one for now.  Let me know when I should add it
back to the next round of stable releases.

thanks,

greg k-h
