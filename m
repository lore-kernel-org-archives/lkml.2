Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1LUM7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:59:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38567 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1LUM7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:59:17 -0500
Message-ID: <1324472337.10752.11.camel@twins>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: mingo@elte.hu, William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>, linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 13:58:57 +0100
In-Reply-To: <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>
References: <20111121145114.049265181@chello.nl>
	 <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 17:36 -0500, Vince Weaver wrote:
> Is it possible to read multiple counters at once with this 
> interface, i.e. using FORMAT_GROUP?

No, that's not something that I had considered, I'll see if I can make
that happen by making an array inside the control page instead of a
single version.

For now you'll have to mmap() the control page for each counter
individually.

> Also, am I correct that the counters are set to always counting, so you 
> always have to do a rdpmc() before and a rdpmc() after?

Depending on how you use it, but yes that's how I'd use it, avoids
having to do ioctl()s

> I used the mmap_read_self() routine from your example as the "read" 
> performance that I measured.

Yeah that's about it, if you want to discard the overload scenario, eg
you use pinned counters or so, you can optimize it further by stripping
out the tsc and scaling muck.

> If start/stop are truly unnecessary when run with your patch then the 
> "total" results shift in your favor.  Otherwise perfmon2 and perfctr still 
> win the self-monitoring overhead race by a lot.

You can of course also do the start/stop/reset in userspace by keeping
an offset to the counter, avoiding the ioctl()s and simply keeping the
counter running.

