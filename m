Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0DUNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:25:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab0DUNZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:25:25 -0400
Subject: Re: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 15:25:24 +0200
Message-ID: <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado,

On Tue, 2010-04-20 at 22:50 +0200, Corrado Zoccolo wrote:
> can you give more information about the setup?
> How much memory do you have, what is the disk configuration (is this a
> hw raid?) and so on.

8G of memory 8-way Xeon CPU, fiber channel attached storage array (HP
HSV200).  I don't know the configuration of the array.

> > low_latency is set to zero in all tests.
> >
> > The layout difference doesn't explain why setting the scheduler to
> > "noop" consistently speeds up read throughput in 8-thread tiobench to
> > almost twice.  This fact alone pretty clearly indicates that the I/O
> > scheduler is the culprit.
> From the attached btt output, I see that a lot of time is spent
> waiting to allocate new request structures.
> > S2G               0.022460311   6.581680621  23.144763751          15
> Since noop doesn't attach fancy data to each request, it can save
> those allocations, thus resulting in no sleeps.
> The delays in allocation, though, may not be completely imputable to
> the I/O scheduler, and working in constrained memory conditions will
> negatively affect it.

I verified with the simple dd test that this happens even if there's no
memory pressure from the cache by dd-ing only 5G of files, after
clearing the cache.  This way ~2G of memory are completely free
throughout the test. 

> > I've also tested with plain "dd" instead of tiobench where the
> > filesystem layout stayed exactly the same between tests.  Still the
> > speed difference is there.
> Does dropping caches before the read test change the situation?

In all my tests I drop caches before running it.

Please let me know if you need more information.

Thanks,
Miklos

