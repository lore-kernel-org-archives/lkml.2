Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab2HVUII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:08:08 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:47010 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab2HVUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:08:03 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2012 16:08:02 EDT
Date: Wed, 22 Aug 2012 23:00:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 08/13] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120822200038.GB27453@bunk.dyndns.info>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-9-git-send-email-koverstreet@google.com>
 <20120822174351.GA27453@bunk.dyndns.info>
 <20120822192241.GA30084@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120822192241.GA30084@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:22:41PM -0700, Kent Overstreet wrote:
> On Wed, Aug 22, 2012 at 08:43:52PM +0300, Adrian Bunk wrote:
> > On Wed, Aug 22, 2012 at 10:04:05AM -0700, Kent Overstreet wrote:
> > >...
> > > --- a/include/linux/blk_types.h
> > > +++ b/include/linux/blk_types.h
> > > @@ -117,6 +117,7 @@ struct bio {
> > >   * BIO_POOL_IDX()
> > >   */
> > >  #define BIO_RESET_BITS	12
> > > +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
> > >...
> > 
> > This doesn't look right.
> 
> Well, the first 12 bits are reset, so bit 12 will get preserved... I
> guess it's unusual to have a duplicated enum value like that but
> BIO_RESET_BITS is just a marker, not a real bit.

Wouldn't a BIO_RESET_MASK be better than BIO_RESET_BITS?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

