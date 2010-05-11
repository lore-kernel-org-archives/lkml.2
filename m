Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0EKNTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab0EKNTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:19:09 -0400
Date: Tue, 11 May 2010 09:18:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [RFC PATCH 1/2] block: allow initialization of previously
 allocated request_queue
Message-ID: <20100511131856.GB25211@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <20100511065520.GK27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511065520.GK27497@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11 2010 at  2:55am -0400,
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, May 10 2010, Mike Snitzer wrote:
> > blk_init_queue() allocates the request_queue structure and then
> > initializes it as needed (request_fn, elevator, etc).
> > 
> > Split initialization out to blk_init_allocated_queue_node.
> > Introduce blk_init_allocated_queue wrapper function to model existing
> > blk_init_queue and blk_init_queue_node interfaces.
> > 
> > Export elv_register_queue to allow a newly added elevator to be
> > registered with sysfs.  Export elv_unregister_queue for symmetry.
> > 
> > These changes allow DM to initialize a device's request_queue with more
> > precision.  In particular, DM no longer unconditionally initializes a
> > full request_queue (elevator et al).  It only does so for a
> > request-based DM device.
> 
> Looks good, I'll apply this. I don't think the exports need to be _GPL
> in this case, generally I've only done that with the exports for hooking
> in a new IO scheduler.

OK, thanks for picking this up.  Do you want me to send v2 that drops
the _GPL or will you make those changes?

Mike
