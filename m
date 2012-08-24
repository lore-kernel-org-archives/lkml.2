Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab2HXUg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:36:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab2HXUg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:36:26 -0400
Date: Fri, 24 Aug 2012 13:36:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Message-ID: <20120824203620.GG21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-13-git-send-email-koverstreet@google.com>
 <20120822210740.GM19212@google.com>
 <20120824062418.GD11977@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824062418.GD11977@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 23, 2012 at 11:24:18PM -0700, Kent Overstreet wrote:
> > I'd prefer simply adding @bioset to bio_clone() so that the caller
> > always has to make the choice consciously.  We're updating all the
> > callers anyway.
> 
> Possibly, but the btrfs code uses bio_clone() and there fs_bio_set may
> be correct (will have to look at what it's doing, if it's cloning a bio
> that was allocated out of fs_bio_set that would be bad..)

Yeah, I think it's generally a good idea to require explicit bioset
specification even if that ends up being fs_bio_set or NULL.

> I would also prefer to simply drop bio_clone() so that
> bio_clone_bioset() matches bio_alloc_bioset(), but regardless that'll
> have to be a different patch (and I don't think I've had to update any
> of the bio_clone() callers in this patch series anyways).

Ooh yeah, bio_clone_bioset() would be the better name for it.

Thanks.

-- 
tejun
