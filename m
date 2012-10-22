Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2JVNpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:45:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:34588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab2JVNpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,629,1344236400"; 
   d="scan'208";a="230633229"
Date: Mon, 22 Oct 2012 06:45:05 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
Message-ID: <20121022134505.GG2095@tassilo.jf.intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
 <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
 <1350902016.2768.85.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350902016.2768.85.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:33:36PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
> > +       /* LBR callstack does not work well with FREEZE_LBRS_ON_PMI */
> > +       if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
> > +               debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI; 
> 
> How useful it is without this? How many calls between PMI and us getting
> to intel_pmu_lbr_read()?

We use it only for ring 3. For ring 0 we assume frame pointer or
dwarf information.

So the CPL filter acts as the freeze.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only
