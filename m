Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1I1H3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:29:10 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36207 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1I1H3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:29:08 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 28 Sep 2011 17:29:07 +1000
In-Reply-To: <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	 <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317194947.1998.18.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:22 +0300, Pekka Enberg wrote:

> > +       while(1) {
> > +               wait_event(d->go, atomic_read(&d->ready) ||
> > +                                 kthread_should_stop());
> > +               if (kthread_should_stop())
> > +                       break;
> 
> So... what happens to the hibernation process when 'kthread_should_stop()'
> returns true?

The compression/decompression threads stop by breaking out of the loop.
At least they should, right? Did I misread some docs here?

PS. I'm not really a kernel programmer, so I'm kinda stumbling my way
through all this.

> > +       nthr = num_online_cpus() - 1;
> > +       nthr = nthr > LZO_THREADS ? LZO_THREADS : (nthr < 1 ? 1 : nthr);
> 
> That's probably one of the most unreadable uses of the ternary
> operator I've ever seen!

Sorry about that. I can simplify.

> What's going on here anyway? Why "num_online_cpus() - 1"? What's wrong with
> 
>   nr_threads = num_online_cpus();
>   if (nr_threads > LZO_THREADS)
>     nr_threads = LZO_THREADS;

We want to keep at least one CPU free for that I/O and for pulling the
other threads into sync when they are done (that is if we have more than
one), right?

> [ And yes, please use less cryptic variable names. ]

OK, been pulled over for that before. Will fix.

> Overall, I really like your patch!

Thanks, hopefully it doesn't blow up too many file systems :-)

-- 
Bojan

