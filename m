Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2G3Plf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:41:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55464 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3Ple (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:41:34 -0400
Date: Mon, 30 Jul 2012 08:41:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [ 13/40] vmscan: shrinker->nr updates race and go wrong
Message-ID: <20120730154130.GC28633@kroah.com>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
 <20120726211412.284677137@linuxfoundation.org>
 <1343593770.4642.11.camel@deadeye.wl.decadent.org.uk>
 <20120730090645.GI612@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730090645.GI612@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:06:45AM +0100, Mel Gorman wrote:
> On Sun, Jul 29, 2012 at 09:29:30PM +0100, Ben Hutchings wrote:
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -251,17 +251,29 @@ unsigned long shrink_slab(struct shrink_
> > >  		unsigned long total_scan;
> > [...]
> > > +		total_scan += delta;
> > > +		if (total_scan < 0) {
> > [...]
> > 
> > This condition is never true since total_scan is unsigned.
> > I think 3.0.y needs this as well:
> > 
> > commit 635697c663f38106063d5659f0cf2e45afcd4bb5
> > Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Date:   Thu Dec 8 14:33:51 2011 -0800
> > 
> >     vmscan: fix initial shrinker size handling
> > 
> 
> You're right, thanks for pointing it out as I missed it. Greg, this commit
> is already in 3.2 but can you pick it up for 3.0-stable please?
> 
> ---8<---
> vmscan: fix initial shrinker size handling
> 
> commit 635697c663f38106063d5659f0cf2e45afcd4bb5 upstream.

Now applied, thanks.

greg k-h
