Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1J0QRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:17:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42791 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1J0QRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:17:07 -0400
Date: Thu, 27 Oct 2011 09:17:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 10/13] block, cfq: unlink cfq_io_context's
 immediately
Message-ID: <20111027161701.GB29899@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
 <20111026213107.GI24261@google.com>
 <20111027143119.GD7491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027143119.GD7491@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 27, 2011 at 10:31:19AM -0400, Vivek Goyal wrote:
> On Wed, Oct 26, 2011 at 02:31:07PM -0700, Tejun Heo wrote:
> >  	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
> > +	if (locked_q)
> > +		lockdep_assert_held(locked_q->queue_lock);
> >  
> 
> Looks like lockdep_assert_held() can't be used if !CONFIG_LOCKDEP. So
> Jens had put following patch to fix one compilation issue. You might
> want to provide a null definition of lockdep_assert_held() in case
> of !CONFIG_LOCKDEP.
> 
> commit 334c2b0b8b2ab186fa198413386cba41fffcb4f2
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Oct 25 15:51:48 2011 +0200
> 
>     blk-throttle: use queue_is_locked() instead of lockdep_is_held()
>     
>     We can't use the latter if !CONFIG_LOCKDEP.
>     
>     Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>

Eh?  lockdep.h has dummy definition if !CONFIG_LOCKDEP.  If
lockdep_is_held() is causing compilation failure on !CONFIG_LOCKDEP,
it's more likely to be have been caused by missing include than
anything else.  Jens, what was the failure?  lockdep_is_held()
provides way better protection against locking mistakes than
spin_is_locked().

Thanks.

-- 
tejun
