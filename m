Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab2HVTWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:22:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288Ab2HVTWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:22:45 -0400
Date: Wed, 22 Aug 2012 12:22:41 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 08/13] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120822192241.GA30084@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-9-git-send-email-koverstreet@google.com>
 <20120822174351.GA27453@bunk.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822174351.GA27453@bunk.dyndns.info>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 08:43:52PM +0300, Adrian Bunk wrote:
> On Wed, Aug 22, 2012 at 10:04:05AM -0700, Kent Overstreet wrote:
> >...
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -117,6 +117,7 @@ struct bio {
> >   * BIO_POOL_IDX()
> >   */
> >  #define BIO_RESET_BITS	12
> > +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
> >...
> 
> This doesn't look right.

Well, the first 12 bits are reset, so bit 12 will get preserved... I
guess it's unusual to have a duplicated enum value like that but
BIO_RESET_BITS is just a marker, not a real bit.
