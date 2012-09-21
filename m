Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab2IUEvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 00:51:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2IUEvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 00:51:19 -0400
Date: Thu, 20 Sep 2012 21:50:46 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 22/26] block: Add bio_alloc_pages()
Message-ID: <20120921045045.GA29160@moria.home.lan>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-23-git-send-email-koverstreet@google.com>
 <20120921004711.GZ7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921004711.GZ7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:47:11PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:33PM -0700, Kent Overstreet wrote:
> > +	bio_for_each_segment_all(bv, bio, i) {
> > +		bv->bv_page = alloc_page(gfp_mask);
> > +		if (!bv->bv_page) {
> > +			while (bv-- != bio->bi_io_vec)
> > +				__free_page(bv->bv_page);
> 
> I don't know.  I feel stupid.  I think it's because the loop variable
> changes between loop condition test and actual body of loop.  How
> about the following?  It is pointing to the member of the same array
> so I think it's not even violating pointer comparison rules.
> 
> 	while (--bv >= bio->bi_io_vec)
> 		__free_page(bv->bv_page);

I can't remember why I did it that way, but I think I like yours better
- I'll change it.
