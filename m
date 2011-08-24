Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1HXH03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:26:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:43471 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1HXH00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:26:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,274,1312182000"; 
   d="scan'208";a="10476398"
Subject: Re: [slub p4 6/7] slub: per cpu cache for partial pages
From: Lin Ming <ming.m.lin@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, "Li, Shaohua" <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF1ivSaH9fh6_QvuBkLc5t=zC4mPEAD5ZzsxOuPruDwG9MiZzw@mail.gmail.com>
References: <20110809211221.831975979@linux.com>
	 <20110809211302.222722588@linux.com>
	 <CAF1ivSaH9fh6_QvuBkLc5t=zC4mPEAD5ZzsxOuPruDwG9MiZzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 15:26:23 +0800
Message-ID: <1314170783.5245.24.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 5:12 AM, Christoph Lameter <cl@linux.com> wrote:
> Allow filling out the rest of the kmem_cache_cpu cacheline with pointers to
> partial pages. The partial page list is used in slab_free() to avoid
> per node lock taking.
> 
> In __slab_alloc() we can then take multiple partial pages off the per
> node partial list in one go reducing node lock pressure.
> 
> We can also use the per cpu partial list in slab_alloc() to avoid scanning
> partial lists for pages with free objects.
> 
> The main effect of a per cpu partial list is that the per node list_lock
> is taken for batches of partial pages instead of individual ones.
> 
> Potential future enhancements:
> 
> 1. The pickup from the partial list could be perhaps be done without disabling
>   interrupts with some work. The free path already puts the page into the
>   per cpu partial list without disabling interrupts.

Nice patches!

Could you share possible ways for this potential enhancement?

Thanks,
Lin Ming

> 
> 2. __slab_free() may have some code paths that could use optimization.


