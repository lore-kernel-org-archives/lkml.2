Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2HOUqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:46:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62832 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HOUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:46:22 -0400
Date: Wed, 15 Aug 2012 13:46:18 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120815204618.GB2758@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-3-git-send-email-koverstreet@google.com>
 <5029E320.3050603@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029E320.3050603@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:33:20PM +0900, Jun'ichi Nomura wrote:
> On 08/07/12 07:08, Kent Overstreet wrote:
> >  struct dm_rq_clone_bio_info {
> >  	struct bio *orig;
> >  	struct dm_rq_target_io *tio;
> > +	struct bio clone;
> >  };
> ...
> > -	pools->bs = bioset_create(pool_size, 0);
> > +	pools->bs = bioset_create(pool_size,
> > +				  offsetof(struct dm_rq_clone_bio_info, orig));
> >  	if (!pools->bs)
> >  		goto free_tio_pool_and_out;
> 
> Shouldn't this be offsetof(struct dm_rq_clone_bio_info, clone)?

Ouch! Yes, it definitely should be. Good catch, and thanks.
