Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0FRBmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 21:42:37 -0400
Received: from ozlabs.org ([203.10.76.45]:40444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0FRBmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 21:42:35 -0400
Date: Fri, 18 Jun 2010 09:31:13 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
Message-ID: <20100617233113.GA2302@brick.ozlabs.ibm.com>
References: <20100616160027.590430763@chello.nl>
 <20100616160238.241599593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616160238.241599593@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:30PM +0200, Peter Zijlstra wrote:

> Simple registration interface for struct pmu, this provides the
> infrastructure for removing all the weak functions.

Nice idea...

> @@ -1011,7 +1001,7 @@ static int hw_perf_cache_event(u64 confi
>  	return 0;
>  }
>  
> -struct pmu *hw_perf_event_init(struct perf_event *event)
> +static int power_pmu_event_init(struct perf_event *event)

How does power_pmu_event_init ever get called now?  I don't see any
other references to it in the patch.  Should struct pmu have a
reference to it?

Paul.
