Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0KEOUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 10:20:09 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:53396 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab0KEOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 10:20:06 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 10:20:05 EDT
Date: Fri, 5 Nov 2010 10:02:01 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Francis Moreau <francis.moro@gmail.com>
cc: Victor Jimenez <victor.javier@bsc.es>,
        Reid Kleckner <reid.kleckner@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
In-Reply-To: <m2wros3pzf.fsf@gmail.com>
Message-ID: <alpine.DEB.2.00.1011051000310.26020@cl320.eecs.utk.edu>
References: <fa.SSgtQesEhEQa5DUYUwBV3fWtoV4@ifi.uio.no> <fa.dD5ur5Phqa1TLmYBE2NVKCQMjTw@ifi.uio.no> <fa.Xj1lA7n6nIJYL40CeRDpQzSKlfc@ifi.uio.no> <fa.xcyA+VzIXesq6qsPU6ADM4xdCKY@ifi.uio.no> <fa.MOg61Pcfdp2SJnwM2GFdOxP+xt0@ifi.uio.no> <fa.4sHfhlc/fMhpYgKda4IfUHZ7jMY@ifi.uio.no>
 <m2wros3pzf.fsf@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Francis Moreau wrote:

> Victor Jimenez <victor.javier@bsc.es> writes:
> 
> [...]
> 
> > If you are measuring last level cache misses, I would recommend you to
> > use a memory intensive application/benchmark instead of /bin/true, as
> > otherwise there can be a significant variation between two runs.
> 
> I agree.
> 
> But still with intensive application, I got the same results:


you're going to need to get your architectural manual for your processor 
and use raw events (not the kernel default ones) if you really want to 
find out what's going on.  A tool like libpfm4 can help change the names 
to raw events for you.

Cache events are very tricky and they often don't return the values you 
expect.  Hardware prefetch can cause some very non-intuitive things to 
happen, and the prefetch only affects certain levels of cache.

Vince
