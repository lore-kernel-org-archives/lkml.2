Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2JVNth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:49:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:64525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2JVNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:49:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,629,1344236400"; 
   d="scan'208";a="236808915"
Date: Mon, 22 Oct 2012 06:49:35 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
Message-ID: <20121022134935.GH2095@tassilo.jf.intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
 <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
 <1350902138.2768.86.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350902138.2768.86.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:35:38PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
> > --- a/include/uapi/linux/perf_event.h
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -160,8 +160,9 @@ enum perf_branch_sample_type {
> >         PERF_SAMPLE_BRANCH_ABORT        = 1U << 7, /* transaction aborts */
> >         PERF_SAMPLE_BRANCH_INTX         = 1U << 8, /* in transaction (flag) */
> >         PERF_SAMPLE_BRANCH_NOTX         = 1U << 9, /* not in transaction (flag) */
> > +       PERF_SAMPLE_BRANCH_CALL_STACK   = 1U << 10, /* call stack */
> >  
> > -       PERF_SAMPLE_BRANCH_MAX          = 1U << 10, /* non-ABI */
> > +       PERF_SAMPLE_BRANCH_MAX          = 1U << 11, /* non-ABI */
> >  }; 
> 
> You add an ABI sample type without mentioning it in your changelog.. I
> think I'll stop reading here.

This is a LBR sample type, not a normal sample type.
I think this is only for when LBR mode is enabled in parallel.
Probably doesn't even make sense. 

For this feature no ABI changes should be needed because it can
be just reported like any other callgraph with the existing callstack
sample type. 

So this could be removed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
