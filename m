Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2BHX1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:27:46 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29020 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755241Ab2BHX1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:27:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQJAKUEM095LD+bgWdsb2JhbABDrhR8IwEBFiYngXIBAQU6HCMQCAMYLhQlAyETumsTiwc3AgIJBQwHBgELAQgFAwMJBgQPAwMBhB0BAwEEDAIKAoJbYwSVLJJy
Date: Thu, 9 Feb 2012 10:27:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Shaohua <shaohua.li@intel.com>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120208232719.GD7479@dastard>
References: <20120208110143.GA5550@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208110143.GA5550@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 07:01:44PM +0800, Wu Fengguang wrote:
> Buffered write(2) is not directly tied to IO, so it's not suitable to
> handle plug in generic_file_aio_write().

But generic_sync_write() does issue IO for O_SYNC writes, so unless
there is plugging at a lower layer in the writeback code then it
appears to me that plugging is still necessary (at least inside the
sync branch)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
