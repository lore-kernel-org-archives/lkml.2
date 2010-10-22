Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0JVNbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0JVNbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:31:03 -0400
Date: Fri, 22 Oct 2010 09:31:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: Fix a gcc 4.5 warning and put some comments
Message-ID: <20101022133101.GA7020@redhat.com>
References: <20101021182403.GA8378@redhat.com>
 <4CC1414B.8070102@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CC1414B.8070102@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 09:46:19AM +0200, Jens Axboe wrote:
> On 2010-10-21 20:24, Vivek Goyal wrote:
> > - Andi encountedred following warning with gcc 4.5
> > 
> >   linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
> >   linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array
> >   bounds
> > 
> > - Warning happens due to following code.
> > 
> >   slice = group_slice * count /
> > 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
> > 		cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
> > 
> >   gcc is complaining about cfqg->busy_queues_avg[] being indexed by CFQ
> >   prio classes (RT, BE and IDLE) while the array size is only 2.
> > 
> > - At run time, we never access cfqg->busy_queues_avg[IDLE] and return from
> >   function before this code hits.
> > 
> > - To fix warning increase the array size though it will remain unused. This
> >   patch also puts some comments to clarify some of the confusions.
> > 
> > - I have taken Jens's patch and modified it a bit.
> > 
> > - Compile tested with gcc 4.4 and boot tested. I don't have gcc 4.5
> >   running, Andi can you please test it with gcc 4.5 to make sure it
> >   worked.
> > 
> > Reported-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Thanks, I'll put this one in. BTW, you can't just add a signed-off-by
> from me (or anyone else, for that matter), they have to be provided
> explicitly by each individual.

Ok, sorry about that.

So in general, if I happen to pick somebody's patch, modify it and repost
it, how do I reflect the Signed-off-by of original author.

Thanks
Vivek
