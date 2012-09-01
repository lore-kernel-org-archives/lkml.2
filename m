Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2IACTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 22:19:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2IACTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 22:19:17 -0400
Date: Fri, 31 Aug 2012 19:19:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v7 7/9] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Message-ID: <20120901021916.GD19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-8-git-send-email-koverstreet@google.com>
 <20120828204401.GF24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828220532.GB1048@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828220532.GB1048@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 28, 2012 at 03:05:32PM -0700, Kent Overstreet wrote:
> On Tue, Aug 28, 2012 at 01:44:01PM -0700, Tejun Heo wrote:
> > On Tue, Aug 28, 2012 at 10:37:34AM -0700, Kent Overstreet wrote:
> > > +static inline struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> > > +{
> > > +	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
> > > +}
> > > +
> > ...
> > > +static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> > > +{
> > > +	return bio_clone_bioset(bio, gfp_mask, NULL);
> > > +
> > > +}
> > 
> > Do we really need these wrappers?  I'd prefer requiring users to
> > explicit choose @bioset when cloning.
> 
> bio_clone() is an existing api, I agree but I'd prefer to convert
> existing users in a separate patch and when I do that I want to spend
> some time actually looking at the existing code instead of doing the
> conversion blindly (at least some of the existing users are incorrect
> and I'll have to add bio_sets for them).

Aren't there like three users in kernel?  If you wanna clean it up
later, that's fine too but I don't think it would make much difference
either way.

Thanks.

-- 
tejun
