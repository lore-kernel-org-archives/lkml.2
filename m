Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2IJBVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:21:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38375 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2IJBVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:21:37 -0400
Date: Sun, 9 Sep 2012 18:21:02 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 0/9] Prep work for immutable bio vecs
Message-ID: <20120910012101.GB23241@moria.home.lan>
References: <1347058760-30794-1-git-send-email-koverstreet@google.com>
 <20120908194115.GC12773@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908194115.GC12773@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 12:41:15PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Fri, Sep 07, 2012 at 03:59:11PM -0700, Kent Overstreet wrote:
> > Random assortment of refactoring and trivial cleanups.
> > 
> > Immutable bio vecs and efficient bio splitting require auditing and removing
> > pretty much all bi_idx uses, among other things.
> > 
> > The reason is that with immutable bio vecs we can't use the bvec array
> > directly; if we have a partially completed bvec, that'll be indicated with a
> > field in struct bvec_iter (which gets embedded in struct bio) - bi_bvec_done.
> > 
> > bio_for_each_segments() will handle this transparently, so code needs to be
> > converted to use it or some other generic accessor.
> > 
> > Also, bio splitting means that when a driver gets a bio, bi_idx and
> > bi_bvec_done may both be nonzero. Again, just need to use generic accessors.
> 
> There are three pending patchsets and I don't know how they're
> supposed to come together.  Please explain on which tree the patches
> are based and how they stack and preferably provide a git branch.

Both of the new ones depend on the block cleanups series, but they
shouldn't depend on each other (bar perhaps some trivial merge
conflicts in bio.h)

Git repo - block_stuff branch on http://evilpiepirate.org/git/linux-bcache.git/
