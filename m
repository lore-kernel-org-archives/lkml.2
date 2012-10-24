Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab2JXMb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:31:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:13788 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758385Ab2JXMbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:31:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="159797026"
Date: Wed, 24 Oct 2012 05:31:24 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 6/7] perf, x86: Use LBR call stack to get user
 callchain
Message-ID: <20121024123124.GU2095@tassilo.jf.intel.com>
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
 <1351058350-9159-7-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBRzwsmzaGFKK9+zOed8HK=Q9T9++hMHW+tSKh4EF0cKjg@mail.gmail.com>
 <5087CF96.7010406@intel.com>
 <CABPqkBRPf-xTozCP75SOLFSLc9OcAvMhKqwfqj_BhLcK-DZK_w@mail.gmail.com>
 <5087D678.1080905@intel.com>
 <CABPqkBS+td3UGSqiSW0+p_B+8SnWhZa38k-bojxHu9k1SGzBLg@mail.gmail.com>
 <CABPqkBQ+YMRvR6mv7NrW4-MZOgW6ztntJV5RMehr+SB9ymkYLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ+YMRvR6mv7NrW4-MZOgW6ztntJV5RMehr+SB9ymkYLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:21:43PM +0200, Stephane Eranian wrote:
> But still, if I do:
> $  perf record -g -e cpu/cycles/k ........
> 
> Looks like your code will activate LBR cstack for user stack even
> though I don't use it.
> I know it won't generate any user samples (theoretically) but you are
> still commandeering
> the LBR resource which other events may want to use.

You can disable it in sysfs. LBR is a power user feature and they will
know how to do this.

See it as a "prefer the needs of the 95+% over the needs of the few" default

-Andi
