Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2EXQTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:19:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab2EXQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:19:20 -0400
Date: Thu, 24 May 2012 09:19:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 01/14] block: Generalized bio pool freeing
Message-ID: <20120524161914.GD27983@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-2-git-send-email-koverstreet@google.com>
 <20120524160944.GB27983@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524160944.GB27983@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:09:44AM -0700, Tejun Heo wrote:
> On Wed, May 23, 2012 at 05:02:38PM -0700, Kent Overstreet wrote:
> > With the old code, when you allocate a bio from a bio pool you have to
> > implement your own destructor that knows how to find the bio pool the
> > bio was originally allocated from.
> > 
> > This adds a new field to struct bio (bi_pool) and changes
> > bio_alloc_bioset() to use it. This makes various bio destructors
> > unnecessary, so they're then deleted.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > Change-Id: I5eb66c1d6910757f4af8755b8857dcbe4619cf8d
> 
> Please drop Change-ID tag and it would be great how you tested the
> changes, other than that,
> 
>  Acked-by: Tejun Heo <tj@kernel.org>

To add a bit here too.  Please explain "why" you're making this
change.  Is it because bi_destructor interface is cumbersome?  Adding
bi_pool is overhead - why is it justified?  Is it because one pointer
is fine to add to struct bio (which I kinda agree) or are there future
changes which will reverse the overhead (which is the case here).

In general, I find the descriptions insufficient.  They don't describe
the reasons and reasoning behind the patch.

Thanks.

-- 
tejun
