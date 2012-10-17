Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2JQSIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:08:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50722 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2JQSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:07:59 -0400
Date: Wed, 17 Oct 2012 20:07:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 0/3] perf_event: enable overflow interrupts on KNC
Message-ID: <20121017180753.GA7291@gmail.com>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> Hello
> 
> the following patchset enables overflow interrupts on Knights Corner,
> the initial KNC PMU driver that was included in 3.7-rc1 did not
> support this.

Nice!

> The first patch should be straightforward.
> The second should be too, but it relates to a problem with the p6 PMU
>     that I brought up in a separate thread.
> The third patch copies code over from the perf_event_intel.c interrupt
>     handler.  Unfortunately KNC and x86 architectural perfmon use
>     different MSR numbers.  The proper fix might be to make this
>     generic and have function vectors for the status/ack functions,
>     but since they are inline and probably performance critical
>     I took the easy way out and just duplicated the code.

The duplication looks pretty limited to me, so I don't think 
it's a problem.

How well tested is this on real hardware and how robust is the 
hardware with this? Since it's a new PMU driver for v3.7, and if 
these are reasonably well tested, then we could send these to 
Linus via perf/urgent, so that they don't miss and have to wait 
all the way to v3.8.

Thanks,

	Ingo
