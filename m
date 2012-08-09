Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2HIGA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:00:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64619 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2HIGAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:00:25 -0400
Date: Wed, 8 Aug 2012 23:00:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 03/12] block: Add bio_reset()
Message-ID: <20120809060019.GA2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-4-git-send-email-koverstreet@google.com>
 <20120808221129.GB6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809000711.GB7262@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809000711.GB7262@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 08, 2012 at 05:07:11PM -0700, Kent Overstreet wrote:
> > > +void bio_reset(struct bio *bio)
> > > +{
> > > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> > 
> > How many flags are we talking about?  If there aren't too many, I'd
> > prefer explicit BIO_FLAGS_PRESERVED or whatever.
> 
> It mostly isn't actual flags that are preserved - the high bits of the
> flags are used for indicating what slab the bvec was allocated from, and
> that's the main thing that has to be preserved.
> 
> So that's why I went with defining the things that are reset instead of
> the things that are preserved.
> 
> I would prefer if bitfields were used for at least BIO_POOL_IDX, but the
> problem is flags is used as an atomic bit vector for BIO_UPTODATE.
> 
> But flags isn't treated as an atomic bit vector elsewhere -
> bio_flagged() doesn't use test_bit(), and flags are set/cleared with

Not using test_bit() may not be necessarily wrong.

> atomic bit operations in some places but not in others (probably _most_
> of them are technically safe, but... ick).

Mixing atomic and non-atomic modifications is almost always wrong tho.

Anyways, understood.  Can you *please* put some comment what bits are
being preserved across reset then?  Things like this aren't obvious at
all and need ample explanation.

Thanks.

-- 
tejun
