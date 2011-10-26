Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1JZUiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1JZUiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:38:51 -0400
Date: Wed, 26 Oct 2011 16:38:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] block, cfq: unlink cfq_io_context's immediately
Message-ID: <20111026203846.GG355@redhat.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
 <20111026194857.GF355@redhat.com>
 <20111026195506.GD24261@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026195506.GD24261@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 12:55:06PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 26, 2011 at 03:48:57PM -0400, Vivek Goyal wrote:
> > > +		ioc_release_depth_inc(cic->q);
> > > +		cic->exit(cic);
> > > +		cic->release(cic);
> > > +		ioc_release_depth_dec(cic->q);
> > 
> > cic->release(cic) can free the cic? Are we accessing cic after freeing it
> > up in ioc_release_depth_dec(cic->q);
> 
> As cic is RCU freed and we're running w/ irq disabled, this shouldn't
> blow up, but yeah, I'll update it to use local variable instead.

Tejun,

So the only reason that cic needs to be rcu protected because in
cfq_cic_lookup() we can access ioc->ioc_data which can point to a 
cic which is not ours and we are not holding queue lock for that and
we can't access cic->q ?

Rest of the places we are either holding ioc_lock or accessing our
own cic under associated queue lock so it should be safe?

I am wondering if there should be a small text file explaining all
the locking in this area.

Good to see that you are cleaning it all up.

Thanks
Vivek
