Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2HHWLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:11:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HHWLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:11:34 -0400
Date: Wed, 8 Aug 2012 15:11:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 03/12] block: Add bio_reset()
Message-ID: <20120808221129.GB6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 06, 2012 at 03:08:32PM -0700, Kent Overstreet wrote:
> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> was open coding it, by doing a bio_init() and resetting bi_destructor.
> 
> v5: Add a define BIO_RESET_BITS, to be very explicit about what parts of
> bio->bi_flags are saved.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Change-Id: I4eb2975bd678d3be811d5423d0620b08020be9ff

Please drop Change-Id.  Die gerrit die.

> +void bio_reset(struct bio *bio)
> +{
> +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);

How many flags are we talking about?  If there aren't too many, I'd
prefer explicit BIO_FLAGS_PRESERVED or whatever.

Thanks.

-- 
tejun
