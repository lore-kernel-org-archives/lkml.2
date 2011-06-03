Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1FCXYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:24:40 -0400
Received: from lunge.queued.net ([66.23.231.200]:45231 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1FCXYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:24:39 -0400
Date: Fri, 3 Jun 2011 16:24:35 -0700
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5535 mfgpt - fix wrong if condition
Message-ID: <20110603162435.0e359a60@queued.net>
In-Reply-To: <20110603161415.49031357.akpm@linux-foundation.org>
References: <BANLkTimR2ggkjDiB9fZDuHJOuFX1Pb=rMw@mail.gmail.com>
	<20110603161415.49031357.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're right, it's reversed.

Acked-by: Andres Salomon <dilinger@queued.net>



On Fri, 3 Jun 2011 16:14:15 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 May 2011 19:08:06 +0000
> Christian Gmeiner <christian.gmeiner@gmail.com> wrote:
> 
> > From: Christian Gmeiner <christian.gmeiner@gmail.com>
> > 
> > This patch fixes the wrong if condition for the check if the
> > requested timer is available.
> > 
> > The bitmap avail is used to store if a timer is used already.
> > test_bit() is used to check if the requested timer is
> > available. If a bit in the avail bitmap is set it means that the
> > timer is available.
> > 
> > Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> > ---
> >  drivers/misc/cs5535-mfgpt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/misc/cs5535-mfgpt.c
> > b/drivers/misc/cs5535-mfgpt.c index e01e08c..bc685bf 100644
> > --- a/drivers/misc/cs5535-mfgpt.c
> > +++ b/drivers/misc/cs5535-mfgpt.c
> > @@ -174,7 +174,7 @@ struct cs5535_mfgpt_timer
> > *cs5535_mfgpt_alloc_timer(int timer_nr, int domain)
> >                 timer_nr = t < max ? (int) t : -1;
> >         } else {
> >                 /* check if the requested timer's available */
> > -               if (test_bit(timer_nr, mfgpt->avail))
> > +               if (!test_bit(timer_nr, mfgpt->avail))
> >                         timer_nr = -1;
> >         }
> > 
> 
> What were the runtime effects of this bug?
> 

The runtime effect would be that allocating a specific timer always
fails (versus telling cs5535_mfgpt_alloc_timer to allocate the first
available timer, which works).


> (Please always include this information in the changelog when fixing
> things)
> 
> Thanks.
