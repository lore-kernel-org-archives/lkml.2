Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1K2DIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:08:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:20285 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab1K2DIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:08:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,588,1315206000"; 
   d="scan'208";a="80048962"
Date: Tue, 29 Nov 2011 11:08:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Li Shaohua <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] readahead: basic support for backwards prefetching
Message-ID: <20111129030809.GB19506@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.887841399@intel.com>
 <20111121153309.d2a410fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121153309.d2a410fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 03:33:09PM -0800, Andrew Morton wrote:
> On Mon, 21 Nov 2011 17:18:26 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Add the backwards prefetching feature. It's pretty simple if we don't
> > support async prefetching and interleaved reads.
> 
> Well OK, but I wonder how many applications out there read files in
> reverse order.  Is it common enough to bother special-casing in the
> kernel like this?

Maybe not so many applications, but sure there are some real cases
somewhere. I remember an IBM paper (that's many years ago, so cannot
recall the exact title) on database shows a graph containing backwards
reading curves among the other ones.

Recently Shaohua even run into a performance regression caused by glibc
optimizing memcpy to access page in reverse order (15, 14, 13, ... 0).

Well this patch may not be the most pertinent fix to that particular
issue. But you see the opportunity such access patterns arise from
surprised areas. 

Thanks,
Fengguang
