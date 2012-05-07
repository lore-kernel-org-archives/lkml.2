Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2EGSHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:07:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2EGSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:07:12 -0400
Date: Mon, 7 May 2012 11:07:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] mm: bootmem: fix checking the bitmap when
 finally freeing bootmem
Message-ID: <20120507180706.GD19417@google.com>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
 <1336390672-14421-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336390672-14421-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:37:43PM +0200, Johannes Weiner wrote:
> From: Gavin Shan <shangw@linux.vnet.ibm.com>
> 
> When bootmem releases an unaligned chunk of memory at the beginning of
> a node to the page allocator, it iterates from that unaligned PFN but
> checks an aligned word of the page bitmap.  The checked bits do not
> correspond to the PFNs and, as a result, reserved pages can be freed.
> 
> Properly shift the bitmap word so that the lowest bit corresponds to
> the starting PFN before entering the freeing loop.
> 
> This bug has been around since 41546c1 "bootmem: clean up
> free_all_bootmem_core" (2.6.27) without known reports.
> 
> Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
