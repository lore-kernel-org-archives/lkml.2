Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0HTVYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:24:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0HTVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimmo2Z174ZG9o0X8HSvzgnc8NTVmkJ6C33BMCda@mail.gmail.com>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
 <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com>
 <1282326182.29609.789.camel@localhost.localdomain> <AANLkTi=racCPiDmbL0pEfH3Ew2_gJzJwmR3B1Vt=AZuz@mail.gmail.com>
 <AANLkTimTZKzXfBJCbzCyq3LwKvn3aCqyHjd5VXhnejfV@mail.gmail.com>
 <1282336944.2605.1395.camel@laptop> <AANLkTimmo2Z174ZG9o0X8HSvzgnc8NTVmkJ6C33BMCda@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 14:24:30 -0700
Message-ID: <AANLkTinGnUaWJbrV7Jcy+Uiu682uE6_2eHr0T3km+ihf@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 2:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Appended is that much smaller patch.

Note that the "real" patch is actually even smaller than implied by
this thing. The diffstat

 include/linux/mm_types.h |    2 +-
 kernel/fork.c            |    7 +++++--
 mm/mmap.c                |   37 +++++++++++++++++++++++++++++++++----
 mm/nommu.c               |    7 +++++--
 4 files changed, 44 insertions(+), 9 deletions(-)

implies that it adds a lot more than it removes, but of the 35 new
lines it adds, about half of it - 16 lines - is just the vma list
verification hack. So it really adds less than 20 lines of code.
Hopefully those 20 lines would then buy themselves back with cleanups.

Still. A doubly-linked list is totally trivial, and I just bet I have
a bug in there somewhere. But looking at your 2007 patch and mine
side-by-side, I do think mine is still less scary.

                     Linus
