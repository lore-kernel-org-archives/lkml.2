Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2JVPgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:36:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:65203 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2JVPgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,630,1344236400"; 
   d="scan'208";a="238568383"
Date: Mon, 22 Oct 2012 08:36:33 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121022153633.GK2095@tassilo.jf.intel.com>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
 <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
 <20121022132733.GQ16230@one.firstfloor.org>
 <20121022133534.GR16230@one.firstfloor.org>
 <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not sure of your notation there. I assume 31..27 means 5 bits (32
> through to 28 inclusive, 27 excluded). That gives you just 2^31 ==

[27...31]

You're right it's only 5 bits, so just 2GB.

Thinking about it more PowerPC has a 16GB page, so we probably
need to move this to prot.

However I'm not sure if any architectures use let's say the high  
8 bits of prot.

> 
> But there seems an obvious solution here: given your value in those
> bits (call it 'n'), the why not apply a multiplier. I mean, certainly
> you never want a value <= 12 for n, and I suspect that the reasonable
> minimum could be much larger (e.g., 2^16). Call that minimum M. Then
> you could interpret the value in your bits as meaning a page size of
> 
>     (2^n) * M

I considered that, but it would seem ugly and does not add that 
many bits.

> 
> > So this will use up all remaining flag bits now.
> 
> On the other hand, that seems really bad. It looks like that kills the
> ability to further extend the mmap() API with new flags in the future.
> It doesn't sound like we should be doing that.

You can always add flags to PROT or add a mmap3(). Has been done before.
Or just don't do any new MAP_SECURITY_HOLEs

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
