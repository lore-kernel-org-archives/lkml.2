Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2KMIow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:44:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2KMIov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:44:51 -0500
Date: Tue, 13 Nov 2012 09:44:46 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Jeff Moyer <jmoyer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, axboe@kernel.dk, dchinner@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
In-Reply-To: <x49k3tvrcci.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1211130944161.3577@localhost>
References: <1350379305-13858-1-git-send-email-lczerner@redhat.com> <x49k3tvrcci.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Jeff Moyer wrote:

> Date: Thu, 08 Nov 2012 16:53:01 -0500
> From: Jeff Moyer <jmoyer@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: axboe@kernel.dk, dchinner@redhat.com, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
> 
> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > +	if (lo->lo_bio_count >= lo->lo_queue->nr_requests) {
> > +		unsigned int nr;
> > +		spin_unlock_irq(&lo->lo_lock);
> > +		nr = lo->lo_queue->nr_requests - (lo->lo_queue->nr_requests/8);
> > +		wait_event_interruptible(lo->lo_req_wait,
> > +					 lo->lo_bio_count < nr);
> > +		spin_lock_irq(&lo->lo_lock);
> > +	}
> 
> So, blk_queue_make_request already initialized q->nr_congestion_on and
> q->nr_congestion_off.  Is there a reason you didn't simply use
> queue_congestion_on_threshold and queue_congestion_off_threshold?

The reason is that I did not knew about those :) Thanks for pointing
it out I'll take a look at it.

Thanks!
-Lukas

> 
> Cheers,
> Jeff
> 
