Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0GELKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:10:24 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47606 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0GELKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:10:22 -0400
Date: Mon, 5 Jul 2010 13:12:13 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 2/2] pcrypt: sysfs interface
Message-ID: <20100705111213.GM10072@secunet.com>
References: <20100629203939.29a0b4ff@leibniz>
 <20100630124742.GD10072@secunet.com>
 <AANLkTimSgp_5LwfvECaAFnW-_UwxwsYVEjKcZTDIHadx@mail.gmail.com>
 <20100702090801.GG10072@secunet.com>
 <AANLkTinFqMtdfvbYDIGjQHoWa3dmUuruTvxG-upUU-7S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinFqMtdfvbYDIGjQHoWa3dmUuruTvxG-upUU-7S@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Jul 2010 11:10:20.0902 (UTC) FILETIME=[A8605860:01CB1C32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 02:20:15PM +0400, Dan Kruchinin wrote:
> On Fri, Jul 2, 2010 at 1:08 PM, Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> > On Thu, Jul 01, 2010 at 06:28:34PM +0400, Dan Kruchinin wrote:
> >> >
> >> > These statistic counters add a lot of atomic operations to the fast-path.
> >> > Would'nt it be better to have these statistics in a percpu manner?
> >> > This would avoid the atomic operations and we would get some additional
> >> > information on the distribution of the queued objects.
> >> >
> >>
> >> If I understood you correctly the resulting sysfs hierarchy would look like
> >> this one:
> >> pcrypt/
> >> |- serial_cpumask
> >> |- parallel_cpumask
> >> |- w0/
> >> +--- parallel_objects
> >> +--- serial_objects
> >> +--- reorder_objects
> >> |- w1/
> >> ...
> >> |- wN/
> >>
> >> right? If so I think it won't be very convenient to monitor summary number
> >> of parallel, serial and reorder objects.
> >
> > Yes, I thought about something like this. You can still take the sum
> > over the percpu objects when you output the statistics.
> 
> But summation can not be clear without some kind of lock because
> while we're summing another CPU can increase or decrease its percpu statistic
> counters. Then each statistic percpu counter must be modified under lock, right?
> 

Thinking a bit longer about this statistics, this statistics work should be
an extra patch. We should focus on the cpumask separation now and think
about this statistics later.

Steffen
