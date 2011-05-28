Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1E1N0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 09:26:45 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:36819 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1E1N0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 09:26:44 -0400
Date: Sat, 28 May 2011 09:26:02 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com, torvalds@linux-foundation.org
Subject: Re: perf: definition of a "regression"
In-Reply-To: <1306578144.1200.1150.camel@twins>
Message-ID: <alpine.DEB.2.00.1105280918510.27439@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>  <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>  <1306233036.2497.15.camel@laptop>  <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
 <1306578144.1200.1150.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Peter Zijlstra wrote:

> On Fri, 2011-05-27 at 23:38 -0400, Vince Weaver wrote:
> > on that note (and while trying to document exactly what the ioctls do) it 
> > seems that a PERF_EVENT_IOC_REFRESH with an argument of anything higher 
> > than one does not work on kernels 2.6.36 and newer.  The behavior acts
> > as if 1 was passed, even if you pass in, say, 3.
> 
> Urgh, no that should definitely work. Thanks for the test-case, I'll
> work on that (probably not until Monday though, but who knows).

So wait, the two regressions I found in 2.6.37 are WONTFIX because they 
are too old, even though they break existing userspace code?

And this older regression in 2.6.36 is going to be fixed, even though
perf, PAPI, and libpfm4 don't trigger the buggy functionality at all?

I think it's time to redefine the PERF_EVENT_IOC_REFRESH ioctl to just
refresh once (as that's what it actually does on 2.6.36 - 2.6.39) and
if we need to refresh multiple we should add a new 
PERF_EVENT_IOC_REFRESH_COUNT ioctl.

I know I am being difficult, but the perf-event ABI is a mess to program 
for in a backward compatible fashion.

Vince
