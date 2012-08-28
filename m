Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2H1WGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:06:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39019 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2H1WGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:06:06 -0400
Date: Tue, 28 Aug 2012 15:05:32 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v7 7/9] block: Add bio_clone_bioset(), bio_clone_kmalloc()
Message-ID: <20120828220532.GB1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-8-git-send-email-koverstreet@google.com>
 <20120828204401.GF24608@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828204401.GF24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:44:01PM -0700, Tejun Heo wrote:
> On Tue, Aug 28, 2012 at 10:37:34AM -0700, Kent Overstreet wrote:
> > +static inline struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> > +{
> > +	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
> > +}
> > +
> ...
> > +static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> > +{
> > +	return bio_clone_bioset(bio, gfp_mask, NULL);
> > +
> > +}
> 
> Do we really need these wrappers?  I'd prefer requiring users to
> explicit choose @bioset when cloning.

bio_clone() is an existing api, I agree but I'd prefer to convert
existing users in a separate patch and when I do that I want to spend
some time actually looking at the existing code instead of doing the
conversion blindly (at least some of the existing users are incorrect
and I'll have to add bio_sets for them).
