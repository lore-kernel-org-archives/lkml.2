Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1LUPET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:04:19 -0500
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:49064 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab1LUPER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:04:17 -0500
Date: Wed, 21 Dec 2011 10:04:15 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Vince Weaver <vweaver1@eecs.utk.edu>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
In-Reply-To: <1324472337.10752.11.camel@twins>
Message-ID: <alpine.DEB.2.02.1112210959540.10098@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl>  <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu> <1324472337.10752.11.camel@twins>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Peter Zijlstra wrote:

> On Fri, 2011-12-16 at 17:36 -0500, Vince Weaver wrote:
> > Is it possible to read multiple counters at once with this 
> > interface, i.e. using FORMAT_GROUP?
> 
> No, that's not something that I had considered, I'll see if I can make
> that happen by making an array inside the control page instead of a
> single version.

well it's not strictly necessary, I was just checking.  The perfctr
code just does a loop through all available counters too.

At some point PAPI should just abandon using FORMAT_GROUP as it seems to 
be more trouble than its worth.  Though if we have fast rdpmc-based 
counter reads it becomes a little less necessary.

> > Also, am I correct that the counters are set to always counting, so you 
> > always have to do a rdpmc() before and a rdpmc() after?
> 
> Depending on how you use it, but yes that's how I'd use it, avoids
> having to do ioctl()s

currently when I tried doing a start ioctl then an immediate read, the 
counter values returned were a very high value.  So unless I did two 
rdpmcs and subtracted, the results made no sense.

was I doing something wrong?  I'll have to investigate more.

> > If start/stop are truly unnecessary when run with your patch then the 
> > "total" results shift in your favor.  Otherwise perfmon2 and perfctr still 
> > win the self-monitoring overhead race by a lot.
> 
> You can of course also do the start/stop/reset in userspace by keeping
> an offset to the counter, avoiding the ioctl()s and simply keeping the
> counter running.

is this guaranteed to work in the face of context switches and/or 
multiplexing?

I need to go back and look at the perfctr code and make sure I understand 
the games it does to ensure that the values it reads out are valid.

Thanks,

Vince

