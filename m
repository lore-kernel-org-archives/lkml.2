Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2HXGYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 02:24:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45226 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2HXGYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 02:24:52 -0400
Date: Thu, 23 Aug 2012 23:24:18 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Message-ID: <20120824062418.GD11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-13-git-send-email-koverstreet@google.com>
 <20120822210740.GM19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822210740.GM19212@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 02:07:40PM -0700, Tejun Heo wrote:
> On Wed, Aug 22, 2012 at 10:04:09AM -0700, Kent Overstreet wrote:
> > Previously, there was bio_clone() but it only allocated from the fs bio
> > set; as a result various users were open coding it and using
> > __bio_clone().
> > 
> > This changes bio_clone() to become bio_clone_bioset(), and then we add
> > bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
> > the functionality the last patch adedd.
> > 
> > This will also help in a later patch changing how bio cloning works.
> 
> I'd prefer simply adding @bioset to bio_clone() so that the caller
> always has to make the choice consciously.  We're updating all the
> callers anyway.

Possibly, but the btrfs code uses bio_clone() and there fs_bio_set may
be correct (will have to look at what it's doing, if it's cloning a bio
that was allocated out of fs_bio_set that would be bad..)

I would also prefer to simply drop bio_clone() so that
bio_clone_bioset() matches bio_alloc_bioset(), but regardless that'll
have to be a different patch (and I don't think I've had to update any
of the bio_clone() callers in this patch series anyways).
