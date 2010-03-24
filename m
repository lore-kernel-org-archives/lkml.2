Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0CXRnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:43:53 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54649 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab0CXRnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:43:52 -0400
Date: Wed, 24 Mar 2010 18:43:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, mkp@mkp.net
Subject: Re: [PATCH 0/5] blkdev: discard optimizations v2 RESEND2
Message-ID: <20100324174350.GH5768@kernel.dk>
References: <1269451988-5270-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269451988-5270-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24 2010, Dmitry Monakhov wrote:
> Wow. lkml seem don't like 'XXX' in the subject
> So post it one more time.

I got it three times :-)

> This is second version of generic discard optimizations
> first was submitted here: http://lwn.net/Articles/373994
> 
> Currently there are many file-systems which has implemented
> discard support, but SSD discs not widely used yet.
> This patch-set introduce compat helpers which simulate
> discard requests with zeroing semantics.
> 
> __blkdev_issue_zeroout: explicitly zeroout given range via write request.
> blkdev_issue_clear: zeroout given range, use discard request if possible.
> 
> Later filesystem admin may select which behavior is suitable for his needs
> discard without zeroing or explicit zeroing even if discard is not supported.
> 
> Advantages:
> - Hope that this helps in real filesystem testing.
> - People who are crazy about data security would be really happy.
> - Virtual machine developers also would like this feature.
> 
> Other optimization:
> - Convert all blkdev_issue_xxx function to common set of flags
> - Optimize generic discard submitting procedure.

I think tihs is pretty odd, to be honest, and a strange way to use a
discard request. If this is some security concern, have some fs helpers
to help them explicitly zero blocks. If you really want to be paranoid,
the single overwrite is likely not enough anyway. Secondly, if used on
an SSD that doesn't have discard, it'll make things worse. Thirdly,
discard may or may not provide zeroed data on re-read.

-- 
Jens Axboe

