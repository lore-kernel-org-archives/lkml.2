Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0JLSZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:25:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54466 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab0JLSZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:25:43 -0400
Date: Tue, 12 Oct 2010 19:25:31 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
Message-ID: <20101012182531.GH30667@csn.ul.ie>
References: <20101005185725.088808842@linux.com> <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:01:35AM +0300, Pekka Enberg wrote:
> (Adding more people who've taken interest in slab performance in the
> past to CC.)
> 

I have not come even close to reviewing this yet but I made a start on
putting it through a series of tests. It fails to build on ppc64

  CC      mm/slub.o
mm/slub.c:1477: warning: 'drain_alien_caches' declared inline after being called
mm/slub.c:1477: warning: previous declaration of 'drain_alien_caches' was here
mm/slub.c: In function `alloc_shared_caches':
mm/slub.c:1748: error: `cpu_info' undeclared (first use in this function)
mm/slub.c:1748: error: (Each undeclared identifier is reported only once
mm/slub.c:1748: error: for each function it appears in.)
mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
mm/slub.c:1748: error: invalid type argument of `unary *'
make[1]: *** [mm/slub.o] Error 1
make: *** [mm] Error 2

I didn't look closely yet but cpu_info is an arch-specific variable.
Checking to see if there is a known fix yet before setting aside time to
dig deeper.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
