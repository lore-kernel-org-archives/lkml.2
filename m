Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162233Ab1FAI60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:58:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:46530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162155Ab1FAI5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:57:45 -0400
Date: Wed, 1 Jun 2011 17:58:16 +0900
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [026/146] block: dont block events on excl write for non-optical
Message-ID: <20110601085816.GA12801@suse.de>
References: <20110601080606.GA522@kroah.com>
 <20110601080253.331790414@blue.kroah.org>
 <20110601081514.GG23067@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601081514.GG23067@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 05:15:14PM +0900, Tejun Heo wrote:
> Hello, Greg.
> 
> On Wed, Jun 01, 2011 at 04:59:22PM +0900, Greg KH wrote:
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> >  devices
> > 
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit d4dc210f69bcb0b4bef5a83b1c323817be89bad1 upstream.
> > 
> > Disk event code automatically blocks events on excl write.  This is
> > primarily to avoid issuing polling commands while burning is in
> > progress.  This behavior doesn't fit other types of devices with
> > removeable media where polling commands don't have adverse side
> > effects and door locking usually doesn't exist.
> > 
> > This patch introduces new genhd flag which controls the auto-blocking
> > behavior and uses it to enable auto-blocking only on optical devices.
> > 
> > Note for stable: 2.6.38 and later only
> 
> This one should be accompanied by the following commit which is
> currently in Jens' tree and will soon be pulled into Linus' tree.
> Sorry about the fuss.  ->check_events() update turned out to be much
> more fragile than I originally expected.  :(
> 
> commit 4c49ff3fe128ca68dabd07537415c419ad7f82f9
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Jun 1 08:27:41 2011 +0200
> 
>     block: blkdev_get() should access ->bd_disk only after success

As I can't take it into -stable until it hits Linus's tree, I'll have to
wait until then.  Hopefully it hits there soon, I'll watch out for it.

thanks for letting me know.

greg k-h
