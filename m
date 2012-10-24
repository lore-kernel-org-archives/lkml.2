Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab2JXMvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:51:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:2086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab2JXMvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:51:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="237564021"
Date: Wed, 24 Oct 2012 05:41:14 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 6/7] perf, x86: Use LBR call stack to get user
 callchain
Message-ID: <20121024124114.GV2095@tassilo.jf.intel.com>
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
 <1351058350-9159-7-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBRzwsmzaGFKK9+zOed8HK=Q9T9++hMHW+tSKh4EF0cKjg@mail.gmail.com>
 <5087CF96.7010406@intel.com>
 <CABPqkBRPf-xTozCP75SOLFSLc9OcAvMhKqwfqj_BhLcK-DZK_w@mail.gmail.com>
 <5087D678.1080905@intel.com>
 <CABPqkBS+td3UGSqiSW0+p_B+8SnWhZa38k-bojxHu9k1SGzBLg@mail.gmail.com>
 <CABPqkBQ+YMRvR6mv7NrW4-MZOgW6ztntJV5RMehr+SB9ymkYLw@mail.gmail.com>
 <20121024123124.GU2095@tassilo.jf.intel.com>
 <CABPqkBQ7dOFpGOLu_Dbyr=HPeBj6mC8Roov7ZpD6v6qUO2JsFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ7dOFpGOLu_Dbyr=HPeBj6mC8Roov7ZpD6v6qUO2JsFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But isn't the whole point of the patch to hide LBR cstack from users so they
> won't know they're using it for user cstack?

The point of the patch is to get user backtraces where you can't
get them today.

> 
> To disable it in sysfs, I need to know it's being used in the first place.

You can always disable unconditionally it if you want to use LBR.

> I think in x86_pmu_hw_config(), you could simply check the priv level
> restrictions on the event. If exclude_user is set, then don't active LBR cstack
> and that's it. That's what I was trying to get to...

Ok that sounds reasonable. Yes it only makes sense for user sampling
currently. However the restriction may be fixed at some point, then
it could be also used for the kernel.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
