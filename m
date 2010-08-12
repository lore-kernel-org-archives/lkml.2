Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab0HLNwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0HLNwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:52:54 -0400
Date: Thu, 12 Aug 2010 09:52:33 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100812135233.GL4879@redhat.com>
References: <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100811220058.GT26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811220058.GT26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:00:58AM +0200, Robert Richter wrote:
> I was debuging this a little more, see version 2 below.
> 
> -Robert
> 
> --
> 
> From 8bb831af56d118b85fc38e0ddc2e516f7504b9fb Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Thu, 5 Aug 2010 16:19:59 +0200
> Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
> 
> When perfctrs are running it is valid to have unhandled nmis, two
> events could trigger 'simultaneously' raising two back-to-back
> NMIs. If the first NMI handles both, the latter will be empty and daze
> the CPU.
> 
> The solution to avoid an 'unknown nmi' massage in this case was simply
> to stop the nmi handler chain when perfctrs are runnning by stating
> the nmi was handled. This has the drawback that a) we can not detect
> unknown nmis anymore, and b) subsequent nmi handlers are not called.
> 
> This patch addresses this. Now, we check this unknown NMI if it could
> be a perfctr back-to-back NMI. Otherwise we pass it and let the kernel
> handle the unknown nmi.

Seems to cover my concerns.  Great work!

ACK

Cheers,
Don
