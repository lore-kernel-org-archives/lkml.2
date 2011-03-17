Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1CQPV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:21:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1CQPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:21:55 -0400
Date: Thu, 17 Mar 2011 16:21:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317152150.GF11094@one.firstfloor.org>
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org> <4D819A2A.8050606@jp.fujitsu.com> <20110317062612.GE11094@one.firstfloor.org> <4D81BB87.10803@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D81BB87.10803@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At least copy to the last page of the huge page is performed after
> all preceding copies are finished.  So I'm not sure it is really
> "a few" or not.
> Still I think making the window smaller than now is worthwhile,
> no matter it is change from 0.1% to 0.01%, or from 0.01% to 0.001%.

Note that hwpoison will never reach 100% coverage. That's impossible.
But to get nearer to 100% it's better to concentrate of the paths
that affect long time windows and significant amounts of memory.
What those are is often non-obvious and needs measurements.

> 
> Or did you find the downside of the check here?

The usual problem is how to test it. That tends to be harder 
than just writing the code. If it's not tested it's probably 
not worth having.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
