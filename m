Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2JVQL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:11:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58996 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab2JVQL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:11:57 -0400
Date: Mon, 22 Oct 2012 18:11:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121022161151.GS16230@one.firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org> <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com> <20121022132733.GQ16230@one.firstfloor.org> <20121022133534.GR16230@one.firstfloor.org> <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com> <20121022153633.GK2095@tassilo.jf.intel.com> <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 05:53:45PM +0200, Michael Kerrisk (man-pages) wrote:
> I'm not sure whether anything is using the high 8 bits of prot, bun
> passing I note that there seems to be no check that the unused bits
> are zeroed so there's a small chance  existing apps are passing random
> garbage there. (Of course, mmap() is hardly the only API to have that
> fault, and it hasn't stopped us from reusing bits in those APIs,
> though sometimes we've gotten bitten by apps that did pass in random
> garbage).

Ok.

> 
> >> But there seems an obvious solution here: given your value in those
> >> bits (call it 'n'), the why not apply a multiplier. I mean, certainly
> >> you never want a value <= 12 for n, and I suspect that the reasonable
> >> minimum could be much larger (e.g., 2^16). Call that minimum M. Then
> >> you could interpret the value in your bits as meaning a page size of
> >>
> >>     (2^n) * M
> >
> > I considered that, but it would seem ugly and does not add that
> > many bits.
> >
> >>
> >> > So this will use up all remaining flag bits now.
> >>
> >> On the other hand, that seems really bad. It looks like that kills the
> >> ability to further extend the mmap() API with new flags in the future.
> >> It doesn't sound like we should be doing that.
> >
> > You can always add flags to PROT or add a mmap3(). Has been done before.
> > Or just don't do any new MAP_SECURITY_HOLEs
> 
> There seems to be a reasonable argument here for an mmap3() with a
> 64-bit flags argument...

It's just a pain to deploy.

I think I would rather do the offset then. That could still handle
PowerPC

14 + 31 = 44 = 16GB           (minimum size 16K)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
