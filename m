Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2H1RXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:23:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41810 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2H1RXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:23:40 -0400
Date: Tue, 28 Aug 2012 10:23:36 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 08/13] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120828172336.GA25749@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-9-git-send-email-koverstreet@google.com>
 <20120822174351.GA27453@bunk.dyndns.info>
 <20120822192241.GA30084@google.com>
 <20120822200038.GB27453@bunk.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822200038.GB27453@bunk.dyndns.info>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:00:38PM +0300, Adrian Bunk wrote:
> On Wed, Aug 22, 2012 at 12:22:41PM -0700, Kent Overstreet wrote:
> > On Wed, Aug 22, 2012 at 08:43:52PM +0300, Adrian Bunk wrote:
> > > On Wed, Aug 22, 2012 at 10:04:05AM -0700, Kent Overstreet wrote:
> > > >...
> > > > --- a/include/linux/blk_types.h
> > > > +++ b/include/linux/blk_types.h
> > > > @@ -117,6 +117,7 @@ struct bio {
> > > >   * BIO_POOL_IDX()
> > > >   */
> > > >  #define BIO_RESET_BITS	12
> > > > +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
> > > >...
> > > 
> > > This doesn't look right.
> > 
> > Well, the first 12 bits are reset, so bit 12 will get preserved... I
> > guess it's unusual to have a duplicated enum value like that but
> > BIO_RESET_BITS is just a marker, not a real bit.
> 
> Wouldn't a BIO_RESET_MASK be better than BIO_RESET_BITS?

Ehh... Might be good to have BIO_RESET_MASK too, but we really want
BIO_RESET_BITS with the flags as that makes it explicit which flags get
cleared and which don't. At first I was going to add BIO_RESET_MASK too,
but it just seemed to get ugly and verbose and didn't fit nicely
anywhere, so I'm dithering and not doing anything with it for now.
