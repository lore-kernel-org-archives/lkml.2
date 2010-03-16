Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab0CPXQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:16:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:49622 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0CPXQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:16:35 -0400
Date: Wed, 17 Mar 2010 08:16:23 +0900
To: beckyb@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, albert_herranz@yahoo.es,
       benh@kernel.crashing.org, linux-usb@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH v4 05/11] swiotlb: add swiotlb_set_default_size()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <C200C089-E6B9-4836-A7B5-3233EB2CE5FB@kernel.crashing.org>
References: <4B9F1E11.80201@yahoo.es>
	<20100316190805Z.fujita.tomonori@lab.ntt.co.jp>
	<C200C089-E6B9-4836-A7B5-3233EB2CE5FB@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100317081003G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 17 Mar 2010 08:16:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 14:28:09 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> 
> On Mar 16, 2010, at 5:08 AM, FUJITA Tomonori wrote:
> 
> > On Tue, 16 Mar 2010 06:58:41 +0100
> > Albert Herranz <albert_herranz@yahoo.es> wrote:
> >
> >> FUJITA Tomonori wrote:
> >>> On Fri, 12 Mar 2010 20:12:40 +0100
> >>> Albert Herranz <albert_herranz@yahoo.es> wrote:
> >>>
> >>>> The current SWIOTLB code uses a default of 64MB for the IO TLB  
> >>>> area.
> >>>> This size can be influenced using a kernel command line parameter  
> >>>> "swiotlb".
> >>>> Unfortunately, the parsing of the kernel command line is done  
> >>>> _after_ the
> >>>> swiotlb is initialized on some architectures.
> >>>>
> >>>> This patch adds a new function swiotlb_set_default_size() which  
> >>>> can be used
> >>>> before swiotlb_init() to indicate the desired IO TLB area size in  
> >>>> bytes.
> >>>>
> >>>> This will be used later to implement a smaller IO TLB on the  
> >>>> Nintendo Wii
> >>>> video game console which just comes with 24MB + 64MB of RAM.
> >>>>
> >>>> CC: linuxppc-dev@lists.ozlabs.org
> >>>> CC: linux-kernel@vger.kernel.org
> >>>> CC: x86@kernel.org
> >>>> CC: linux-ia64@vger.kernel.org
> >>>> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> >>>> ---
> >>>> include/linux/swiotlb.h |    2 ++
> >>>> lib/swiotlb.c           |   20 ++++++++++++++++++++
> >>>> 2 files changed, 22 insertions(+), 0 deletions(-)
> >>>
> >>> Please fix the powerpc swiotlb initialization instead.
> >>>
> >>> Calling swiotlb_init() before parsing kernel parameters sounds
> >>> wrong. Any reasons why you can't fix it?
> >>>
> >>
> >> I think that this would be better asked by a PowerPC maintainer. Ben?
> >>
> >> If this is really a problem the swiotlb late init may be a solution  
> >> too in this particular case.
> >
> > Hmm, why swiotlb_late_init_with_default_size()?
> >
> > Why can't you initialize swiotlb in mem_init() like this (only compile
> > tested)? Any time before freeing bootmem works for swiotlb.
> 
> This is an oops in the original patchset -  I think it should be fine  
> to move the swiotlb_init later as Fujita suggests, at least for 32-bit  
> powerpc.  I just booted this on mpc8641 and everything seems OK.

Thanks!

I'll resend this patch in the proper format. This patch fixes the
problem that powerpc ignores swiotlb boot options so we can merge it
independent of Albert's patchset.
