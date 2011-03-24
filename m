Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab1CXSry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:47:54 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:49195 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1CXSrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:47:53 -0400
Date: Thu, 24 Mar 2011 19:47:51 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110324184751.GA1696@gentoo.trippels.de>
References: <4D8B4A89.80608@fusionio.com>
 <20110324183019.GA1676@gentoo.trippels.de>
 <4D8B8F34.5000203@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B8F34.5000203@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.24 at 19:36 +0100, Jens Axboe wrote:
> On 2011-03-24 19:30, Markus Trippelsdorf wrote:
> > On 2011.03.24 at 14:43 +0100, Jens Axboe wrote:
> >>
> >> This is the main pull request for the block IO layer and friends for
> >> 2.6.39.
> > 
> > This merge results in an early oops on my system (amd64, xfs).
> > See the attached photo.
> > 
> 
> Auch. Can you ensure that you have CONFIG_DEBUGINFO=y in your .config
> and then do:
> 
> $ gdb vmlinux
> ...
> l *cfq_insert_request+0x32
> 
> and send that output?

(gdb) l *cfq_insert_request+0x32
0xffffffff81265ad2 is in cfq_insert_request (block/cfq-iosched.c:3396).
3391    {
3392            struct cfq_data *cfqd = q->elevator->elevator_data;
3393            struct cfq_queue *cfqq = RQ_CFQQ(rq);
3394
3395            cfq_log_cfqq(cfqd, cfqq, "insert_request");
3396            cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
3397
3398            rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
3399            list_add_tail(&rq->queuelist, &cfqq->fifo);
3400            cfq_add_rq_rb(rq);
(gdb)

-- 
Markus
