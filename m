Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161868Ab1FAJNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:13:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40585 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161808Ab1FAIPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sspBYsVvWBvXJJX74Co2S9AFnMgdNUObCMZKeRp7yQixmInTM1oSqkctfYeH5ysiSP
         97RGQLPIzevYbuKcxomWDkLizAmnObY24YNg15YaQzS0ql1KlRjhgKqHGVngMOBniWYB
         5R4rSqT2NAoz48vIQh0l+tJ8Yuzis8lwBDrgI=
Date: Wed, 1 Jun 2011 17:15:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [026/146] block: dont block events on excl write for non-optical
Message-ID: <20110601081514.GG23067@mtj.dyndns.org>
References: <20110601080606.GA522@kroah.com>
 <20110601080253.331790414@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601080253.331790414@blue.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Wed, Jun 01, 2011 at 04:59:22PM +0900, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
>  devices
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit d4dc210f69bcb0b4bef5a83b1c323817be89bad1 upstream.
> 
> Disk event code automatically blocks events on excl write.  This is
> primarily to avoid issuing polling commands while burning is in
> progress.  This behavior doesn't fit other types of devices with
> removeable media where polling commands don't have adverse side
> effects and door locking usually doesn't exist.
> 
> This patch introduces new genhd flag which controls the auto-blocking
> behavior and uses it to enable auto-blocking only on optical devices.
> 
> Note for stable: 2.6.38 and later only

This one should be accompanied by the following commit which is
currently in Jens' tree and will soon be pulled into Linus' tree.
Sorry about the fuss.  ->check_events() update turned out to be much
more fragile than I originally expected.  :(

commit 4c49ff3fe128ca68dabd07537415c419ad7f82f9
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Jun 1 08:27:41 2011 +0200

    block: blkdev_get() should access ->bd_disk only after success

Thank you.

-- 
tejun
