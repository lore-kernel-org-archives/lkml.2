Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0K3TjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:39:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:54168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0K3TjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:39:03 -0500
Subject: Re: [thisops uV3 07/18] highmem: Use this_cpu_xx_return()
 operations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
In-Reply-To: <1291145391.2904.247.camel@edumazet-laptop>
References: <20101130190707.457099608@linux.com>
	 <20101130190845.216537525@linux.com>
	 <1291144408.2904.232.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011301325180.3134@router.home>
	 <1291145391.2904.247.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 20:38:30 +0100
Message-ID: <1291145910.32004.1166.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 20:29 +0100, Eric Dumazet wrote:
> 
> well maybe a single prototype ;)
> 
> static inline void kmap_atomic_idx_pop(void)
> {
> #ifdef CONFIG_DEBUG_HIGHMEM
>         int idx = __this_cpu_dec_return(__kmap_atomic_idx);
>         BUG_ON(idx < 0);
> #else
>       __this_cpu_dec(__kmap_atomic_idx);
> #endif
> } 

Right, at least a consistent prototype, the above looks fine to me.
