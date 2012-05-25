Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab2EYUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:47:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2EYUrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:47:13 -0400
Date: Fri, 25 May 2012 16:46:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        yehuda@hq.newdream.net, mpatocka@redhat.com, vgoyal@redhat.com,
        bharrosh@panasas.com, tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120525204651.GA24246@redhat.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337977539-16977-15-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25 2012 at  4:25pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> Since generic_make_request() can now handle arbitrary size bios, all we
> have to do is make sure the bvec array doesn't overflow.

I'd love to see the merge_bvec stuff go away but it does serve a
purpose: filesystems benefit from accurately building up much larger
bios (based on underlying device limits).  XFS has leveraged this for
some time and ext4 adopted this (commit bd2d0210cf) because of the
performance advantage.

So if you don't have a mechanism for the filesystem's IO to have
accurate understanding of the limits of the device the filesystem is
built on (merge_bvec was the mechanism) and are leaning on late
splitting does filesystem performance suffer?

Would be nice to see before and after XFS and ext4 benchmarks against a
RAID device (level 5 or 6).  I'm especially interested to get Dave
Chinner's and Ted's insight here.

Mike
