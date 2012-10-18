Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2JRRyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:54:06 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56452 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2JRRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:54:04 -0400
Date: Thu, 18 Oct 2012 13:54:47 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 0/3] perf_event: enable overflow interrupts on KNC
In-Reply-To: <20121017214700.GA9851@gmail.com>
Message-ID: <alpine.DEB.2.02.1210181339510.28924@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu> <20121017180753.GA7291@gmail.com> <alpine.DEB.2.02.1210171614060.23685@vincent-weaver-1.um.maine.edu> <20121017214700.GA9851@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Ingo Molnar wrote:

> > Since the knc pmu driver closely models the p6 one, it was 
> > straightforward to use it as a basis for the forward port.  
> > Everything _should_ work but I've only compile tested.
> 
> Ok. As long as it's all identical I'd still be inclined to 
> include it in v3.7, to reduce version skew. If the v3.7-rc1 
> kernel won't even boot it's not like we'll be able to further 
> regress it.

yes, it definitely shouldn't cause any regressions, and in fact the
version in 3.7-rc1 might not work properly without patch2 in this 
set applied due to the cpuc->enabled problem that it took us a while to 
track down.

I looked into getting a 3.7 kernel up and going on the KNC board, but
the diff between Intel's release and stock 2.6.34.11 has 70k 
lines.  Much of that is kdb, but there's also a lot of low-level 
changes too, some of it due to the fact that KNC is 64-bit x86 but has no 
support for SSE (so you need to handle that properly or none of your 
userspace will run).

Thanks,

Vince Weaver
vincent.weaver@maine.edu
