Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1AYUrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:47:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:45261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab1AYUrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:47:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,376,1291622400"; 
   d="scan'208";a="700551742"
Message-ID: <4D3F36CB.6060505@linux.intel.com>
Date: Tue, 25 Jan 2011 12:47:07 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 00/25] mm: Preemptibility -v7
References: <20110125173111.720927511@chello.nl>	 <m2ipxcsr6v.fsf@linux.intel.com> <1295987985.28776.1118.camel@laptop>
In-Reply-To: <1295987985.28776.1118.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Its nesting hundreds of spinlocks (255+) make the preempt debug code
> unhappy, it also causes fun latencies when you do start KVM/GRU
> Although arguably that's the least convincing reason to do all this its
> the one that got me to actually compose this series -- I really should
> write a new leader..
Least Convincing is a good description...
Tuning operations which only happen once is not very interesting, 
especially if that affects
fast paths.

> Making all this preemptible also allows making the whole mmu_gather
> thing preemptible, which is something we've wanted to do for a long
> while, it also allows XPMEM or whatever that thing was called (Andrea
> knows) and of course, it moves a part of -rt upstream.

I thought the reason for the preempt off inside the mmu gather region was
to stay on the same CPU for local/remote flushes. How would it change that?

> If we decide to keep patch 24, it also simplifies the truncate path
> quite a bit.
That sounds like a good thing. Making truncate simpler is always good.

-Andi
