Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0GBJGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:06:30 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42429 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976Ab0GBJGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:06:25 -0400
Date: Fri, 2 Jul 2010 11:08:01 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 2/2] pcrypt: sysfs interface
Message-ID: <20100702090801.GG10072@secunet.com>
References: <20100629203939.29a0b4ff@leibniz>
 <20100630124742.GD10072@secunet.com>
 <AANLkTimSgp_5LwfvECaAFnW-_UwxwsYVEjKcZTDIHadx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimSgp_5LwfvECaAFnW-_UwxwsYVEjKcZTDIHadx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jul 2010 09:06:23.0567 (UTC) FILETIME=[D823D5F0:01CB19C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 06:28:34PM +0400, Dan Kruchinin wrote:
> >
> > These statistic counters add a lot of atomic operations to the fast-path.
> > Would'nt it be better to have these statistics in a percpu manner?
> > This would avoid the atomic operations and we would get some additional
> > information on the distribution of the queued objects.
> >
> 
> If I understood you correctly the resulting sysfs hierarchy would look like
> this one:
> pcrypt/
> |- serial_cpumask
> |- parallel_cpumask
> |- w0/
> +--- parallel_objects
> +--- serial_objects
> +--- reorder_objects
> |- w1/
> ...
> |- wN/
> 
> right? If so I think it won't be very convenient to monitor summary number
> of parallel, serial and reorder objects.

Yes, I thought about something like this. You can still take the sum
over the percpu objects when you output the statistics.


> Anyway I think these atomic operations take very small time in comparison
> with other operations in padata. So small that it can be ignored.

I have a patch in queue that simplifies the serialization mechanism and
reduces the accesses of foreign and global memory as much as possible
in the parallel codepath. Adding atomic operations to global memory
(just to collect statistics) to the parallel codepath would go in the
opposite direction. 

Steffen
