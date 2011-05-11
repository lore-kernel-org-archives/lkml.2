Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1EKQXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332Ab1EKQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:17:05 -0400
Date: Wed, 11 May 2011 10:28:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: fix typos on struct throtl_grp init code
Message-ID: <20110511142853.GE31633@redhat.com>
References: <20110511130732.GB31633@redhat.com>
 <1305120045-5111-1-git-send-email-namhyung@gmail.com>
 <20110511133033.GD31633@redhat.com>
 <1305123242.1561.20.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1305123242.1561.20.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:14:02PM +0900, Namhyung Kim wrote:
> 2011-05-11 (수), 09:30 -0400, Vivek Goyal:
> > On Wed, May 11, 2011 at 10:20:45PM +0900, Namhyung Kim wrote:
> > > s/td/tg/
> > 
> > I think jens would like to have little more changelog than that.
> > 
> 
> OK, let me clarify this first: My first patch was trivial but second one
> seems not. AFAICS it could affect when the bps/iops bandwidth change
> applies - maybe delayed to next @tg->disptime? - if there are concurrent
> cgroup init and limit change tasks, right? Or do you have something need
> to be included in the changelog?

Just say that when a new group is initialized, set tg->limits_changed =
false instead of setting td->limits_changed to false.

We do memset 0 on all newly allocated objects to this might not be
required at all. 

So how about just getting rid of td->limits_changed assignments and
not do explicit tg->limits_changed as that is implicit in zeroing of
newly allocated object.

Thanks
Vivek


> 
> 
> > Otherwise looks good to me.
> > 
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > 
> > Vivek
> 
> Thank you for the review and the comment.
> 
> 
> -- 
> Regards,
> Namhyung Kim
> 
