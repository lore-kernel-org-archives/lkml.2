Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1KDROs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:14:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab1KDROr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:14:47 -0400
Date: Fri, 4 Nov 2011 10:14:26 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [050/107] block: check for proper length of iov entries earlier
 in blk_rq_map_user_iov()
Message-ID: <20111104171425.GA4893@suse.de>
References: <20111102221600.GA26650@kroah.com>
 <20111102221454.703920975@clark.kroah.org>
 <1320420256.3079.172.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320420256.3079.172.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 03:24:16PM +0000, Ben Hutchings wrote:
> On Wed, 2011-11-02 at 15:14 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Xiaotian Feng <dfeng@redhat.com>
> > 
> > commit 5478755616ae2ef1ce144dded589b62b2a50d575 upstream.
> > 
> > commit 9284bcf checks for proper length of iov entries in
> > blk_rq_map_user_iov(). But if the map is unaligned, kernel
> > will break out the loop without checking for the proper length.
> > So we need to check the proper length before the unalign check.
> 
> This will catch an unaligned zero-length entry.  But there's still no
> check for zero-length iov entries *after* the unaligned entry.
> 
> [...]
> > --- a/block/blk-map.c
> > +++ b/block/blk-map.c
> > @@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_q
> >  	for (i = 0; i < iov_count; i++) {
> >  		unsigned long uaddr = (unsigned long)iov[i].iov_base;
> >  
> > +		if (!iov[i].iov_len)
> > +			return -EINVAL;
> > +
> >  		if (uaddr & queue_dma_alignment(q)) {
> >  			unaligned = 1;
> >  			break;
> 
> I think the correct fix is just to remove the 'break'.

Then the fix should go upstream first :)

thanks,

greg k-h
