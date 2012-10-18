Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2JRSyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:54:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38514 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2JRSym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:54:42 -0400
Date: Thu, 18 Oct 2012 20:54:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 0/3] perf_event: enable overflow interrupts on KNC
Message-ID: <20121018185437.GA21109@gmail.com>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
 <20121017180753.GA7291@gmail.com>
 <alpine.DEB.2.02.1210171614060.23685@vincent-weaver-1.um.maine.edu>
 <20121017214700.GA9851@gmail.com>
 <alpine.DEB.2.02.1210181339510.28924@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210181339510.28924@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> I looked into getting a 3.7 kernel up and going on the KNC 
> board, but the diff between Intel's release and stock 
> 2.6.34.11 has 70k lines.  Much of that is kdb, but there's 
> also a lot of low-level changes too, some of it due to the 
> fact that KNC is 64-bit x86 but has no support for SSE (so you 
> need to handle that properly or none of your userspace will 
> run).

Getting that support upstream would definitely be useful, so if 
you feel so inclined splitting out (or creating anew) the 
required patches ...

I don't know how it's structured, but making the !SSE 
distinction runtime would be strongly preferred over any 
compile-time .config switchery. Otherwise, the guiding principle 
is that we'll do whatever it takes to support the hardware, with 
the reasonably best possible cleanliness.

Thanks,

	Ingo
