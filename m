Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2BWQVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:21:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51796 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2BWQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:21:14 -0500
Date: Thu, 23 Feb 2012 17:21:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, tim.c.chen@linux.intel.com
Subject: Re: [PATCH v3 21/21] mm: zone lru vectors interleaving
Message-ID: <20120223162111.GA4713@one.firstfloor.org>
References: <20120223133728.12988.5432.stgit@zurg> <20120223135328.12988.87152.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223135328.12988.87152.stgit@zurg>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config PAGE_LRU_SPLIT
> +	int "Memory lru lists per zone"
> +	default	4 if EXPERIMENTAL && SPARSEMEM_VMEMMAP
> +	default 1
> +	help
> +	  The number of lru lists in each memory zone for interleaving.
> +	  Allows to redeuce lru_lock contention, but adds some overhead.
> +	  Without SPARSEMEM_VMEMMAP might be costly. "1" means no split.

Could you turn those two numbers into a boot option? Compile time 
parameters are nasty to use.

I suppose it's ok to have an upper limit.

> +
> +config PAGE_LRU_INTERLEAVING
> +	int "Memory lru lists interleaving page-order"
> +	default	12
> +	help
> +	  Page order for lru lists interleaving. By default 12 (16Mb).
> +	  Must be greater than huge-page order.
> +	  With CONFIG_PAGE_LRU_SPLIT=1 has no effect.

-Andi
