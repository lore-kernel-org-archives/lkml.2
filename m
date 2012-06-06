Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2FFOQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:16:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:46564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2FFOQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:16:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175508345"
Date: Wed, 6 Jun 2012 07:16:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading
 counters
Message-ID: <20120606141644.GF28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338944211-28275-5-git-send-email-andi@firstfloor.org>
 <1338979579.2749.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338979579.2749.95.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:46:19PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > RDPMC is much faster than RDMSR for reading performance counters,
> > since it's not serializing.  Use it if possible in the perf handler.
> > 
> > Only tested on Sandy Bridge, so I only enabled it there so far.
> 
> That's just stupid.. I took Vince's patch from a while back.

What do you mean? It's significantly faster to read the counters this
way, because it avoids serialization and other overhead. 

Vince's patch only enabled it for user space I believe, This is for lowering
the kernel PMI handler overhead.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
