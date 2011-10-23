Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1JWObN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:31:13 -0400
Received: from serv04.lahn.de ([213.239.197.57]:32919 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab1JWObM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:31:12 -0400
Date: Sun, 23 Oct 2011 16:30:42 +0200
From: Michael Leun <ml@newton.leun.net>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Bisected: Massive memory leak in dm-snapshot in 3.1 development
 introduced
Message-ID: <20111023163042.4a93936c@xenia.leun.net>
In-Reply-To: <20111023134449.GA13703@agk-dp.fab.redhat.com>
References: <20111023112140.37fd8b3d@xenia.leun.net>
	<CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
	<20111023134449.GA13703@agk-dp.fab.redhat.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011 14:44:49 +0100
Alasdair G Kergon <agk@redhat.com> wrote:

> On Sun, Oct 23, 2011 at 12:52:06PM +0300, Linus Torvalds wrote:
> > Mikulas, Alasdair? I see the mempool_free() for the "master job",
> > what about everything else? Does the dm_kcopyd_prepare_callback()
> > perhaps need to do a
> > 
> >     job->master_job = job;
> > 
> > or similar?
> 
> If you look at the other place that performs that mempool_alloc, it's
> indeed present there.
> 
> Michael - can you test if this solves the problem?
> 
> Alasdair
> 
> --- a/drivers/md/dm-kcopyd.c
> +++ b/drivers/md/dm-kcopyd.c
> @@ -628,6 +628,7 @@ void *dm_kcopyd_prepare_callback(struct
> dm_kcopyd_client *kc, job->kc = kc;
>  	job->fn = fn;
>  	job->context = context;
> +	job->master_job = job;
>  
>  	atomic_inc(&kc->nr_jobs);
>  
> 

Yup, it indeed does.

-- 
MfG,

Michael Leun

