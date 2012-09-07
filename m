Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2IGU6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:58:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37782 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2IGU61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:58:27 -0400
Date: Fri, 7 Sep 2012 13:58:23 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH v10 4/8] block: Add bio_reset()
Message-ID: <20120907205823.GD16360@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-5-git-send-email-koverstreet@google.com>
 <50494F1A.4080207@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50494F1A.4080207@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 07:34:18PM -0600, Jens Axboe wrote:
> On 2012-09-06 16:34, Kent Overstreet wrote:
> > Reusing bios is something that's been highly frowned upon in the past,
> > but driver code keeps doing it anyways. If it's going to happen anyways,
> > we should provide a generic method.
> > 
> > This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> > was open coding it, by doing a bio_init() and resetting bi_destructor.
> > 
> > This required reordering struct bio, but the block layer is not yet
> > nearly fast enough for any cacheline effects to matter here.
> 
> That's an odd and misplaced comment. Was just doing testing today at 5M
> IOPS, and even years back we've had cache effects for O_DIRECT in higher
> speed setups.

Ah, I wasn't aware that you were pushing that many iops through the
block layer - most I've tested myself was around 1M. It wouldn't
surprise me if cache effects in struct bio mattered around 5M...

> That said, we haven't done cache analysis in a long time. So moving
> members around isn't necessarily a huge deal.

Ok, good to know. I've got another patch coming later that reorders
struct bio a bit more, for immutable bvecs (bi_sector, bi_size, bi_idx
go into a struct bvec_iter together).

> Lastly, this isn't a great commit message for other reasons. Anyone can
> see that it moves members around. It'd be a lot better to explain _why_
> it is reordering the struct.

Yeah, I suppose so. Will keep that in mind for the next patch.

> 
> BTW, I looked over the rest of the patches, and it looks OK to me.

Resent them. Thanks!
