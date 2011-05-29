Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1E2QyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:54:20 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:51571 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1E2QyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:54:19 -0400
Date: Sun, 29 May 2011 12:54:00 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306578144.1200.1150.camel@twins>
Message-ID: <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
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
> 

after a painfully long bisection, it turns out that this problem was in
theory introduced by the following commit:

  d57e34fdd60be7ffd0b1d86bfa1a553df86b7172

  perf: Simplify the ring-buffer logic: make perf_buffer_alloc() do everything needed

I'll see if I can come up with a patch, but it's a bit non-obvious why
this commit is affecting the REFRESH value at all.

Vince
vweaver1@eecs.utk.edu
