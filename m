Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1KAMtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:49:05 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50468 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754495Ab1KAMtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:49:04 -0400
Date: Tue, 1 Nov 2011 08:48:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ben Hutchings <ben@decadent.org.uk>, Jason Baron <jbaron@redhat.com>,
        Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module: Enable dynamic debugging regardless of taint
Message-ID: <20111101124859.GA1698@Krystal>
References: <1319773094.6759.32.camel@deadeye> <87obwxq5tz.fsf@rustcorp.com.au> <1320068657.6759.107.camel@deadeye> <87r51svbit.fsf@rustcorp.com.au> <1320119973.30281.7.camel@deadeye> <87lis0v4ih.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <87lis0v4ih.fsf@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:45:16 up 572 days, 22:34,  3 users,  load average: 0.24, 0.19,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Tue, 01 Nov 2011 03:59:33 +0000, Ben Hutchings <ben@decadent.org.uk> wrote:
> > Dynamic debugging is currently disabled for tainted modules, except
> > for TAINT_CRAP.  This prevents use of dynamic debugging for
> > out-of-tree modules now that they are also tainted.
> > 
> > This condition was apparently intended to avoid a crash if a force-
> > loaded module has an incompatible definition of dynamic debug
> > structures.  However, a administrator that forces us to load a module
> > is claiming that it *is* compatible even though it fails our version
> > checks.  If they are mistaken, there are any number of ways the module
> > could crash the system.
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> 
> Thanks, applied, unless Mathieu objects...

I'm OK with that. We should probably note in the changelog the
side-effect of now supporting dynamic debugging of proprietary drivers.
If we start doing this for dynamic debugging, I'd be tempted to do it
for tracepoints and static jump labels too, since at least tracepoints
would not be the only "offender" (from an end-user point of view)
causing crashes on incompatible module load.

Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Cheers,
> Rusty.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
