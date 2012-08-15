Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2HOCa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 22:30:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:14568 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2HOCa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 22:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,770,1336374000"; 
   d="scan'208";a="201194701"
Date: Wed, 15 Aug 2012 10:30:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Salter <msalter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-c6x-dev@linux-c6x.org, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
Message-ID: <20120815023050.GA24641@localhost>
References: <20120814153413.GA18601@localhost>
 <1344961371.30830.43.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344961371.30830.43.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 12:22:49PM -0400, Mark Salter wrote:
> On Tue, 2012-08-14 at 23:34 +0800, Fengguang Wu wrote:
> > Sorry I have no compilers for build testing these changes, however the
> > risk looks low and it's much better than to leave the arch broken,
> > considering that Eric will do atomic64_t in the core fs/namespace.c
> > code.
> > 
> > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> > ---
> > 
> > Andrew: the arch maintainers have been CCed. Best is the maintainers
> > respond, test and perhaps take the corresponding change. Let's see how
> > this will work out..
> > 
> > 
> >  arch/c6x/Kconfig       |    1 +
> 
> The c6x port also needs this:
> 
> C6X: add L*_CACHE_SHIFT defines
>     
> C6X currently lacks L*_CACHE_SHIFT defines which are used in a few
> places in the generic kernel. This patch adds those missing defines.
>     
> Signed-off-by: Mark Salter <msalter@redhat.com>

Thanks for the quick fix! git grep shows this:

        lib/atomic64.c: addr >>= L1_CACHE_SHIFT;

So this patch is a prerequisite for the GENERIC_ATOMIC64 patch.

git grep also shows

        arch/score/include/asm/cache.h:#define L1_CACHE_SHIFT           4

        arch/unicore32/include/asm/cache.h:#define L1_CACHE_SHIFT (5)

So the other two archs are fine.

Thanks,
Fengguang
