Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2HVTv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:51:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2HVTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:51:53 -0400
Date: Wed, 22 Aug 2012 12:51:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 03/13] block: Add bio_reset()
Message-ID: <20120822195148.GF19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-4-git-send-email-koverstreet@google.com>
 <20120822183426.GD19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822183426.GD19212@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:34:26AM -0700, Tejun Heo wrote:
> On Wed, Aug 22, 2012 at 10:04:00AM -0700, Kent Overstreet wrote:
> > Reusing bios is something that's been highly frowned upon in the past,
> > but driver code keeps doing it anyways. If it's going to happen anyways,
> > we should provide a generic method.
> > 
> > This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> > was open coding it, by doing a bio_init() and resetting bi_destructor.
> > 
> > v5: Add a define BIO_RESET_BITS, to be very explicit about what parts of
> > bio->bi_flags are saved.
> > v6: Further commenting verbosity, per Tejun
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> 
> Given some users are converted later.
> 
>  Acked-by: Tejun Heo <tj@kernel.org>

Noticed it was a bit fuzzy which fields get reset and which aren't and
had a off-line discussion with Kent.  The conclusion was that
bi_end_io and bi_private should be reset and bi_integrity should be
freed on bio_reset().

Thanks.

-- 
tejun
