Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0G1OVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:21:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:59656 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0G1OVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:21:32 -0400
Date: Wed, 28 Jul 2010 23:20:59 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, ak@linux.intel.com, konrad.wilk@oracle.com,
        akataria@vmware.com, lenb@kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        petr@vmware.com
Subject: Re: swiotlb detection should be memory hotplug aware ?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <8739v3kgl6.fsf@basil.nowhere.org>
References: <4C49B3F5.3030904@linux.intel.com>
	<20100728190939D.fujita.tomonori@lab.ntt.co.jp>
	<8739v3kgl6.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100728232026V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Jul 2010 23:21:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 13:09:57 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> >
> >> The other problem is that using only  two bits for the needed address 
> >> space is also extremly
> >> inefficient (4GB and 16MB on x86). Really want masks everywhere and 
> >> optimize for the
> >> actual requirements.
> >
> > swiotlb doesn't allocate GFP_DMA memory. It handles only GFP_DMA32.
> 
> I was lumping GFP_DMA and swiotlb together here. The
> pci_alloc_consistent() function uses both interchangedly.
> They really effectively are the same thing these days
> and just separated by historical accident.

Sorry, I meant to ZONE_DMA.

You are talking about your dma mask allocation patchset, right?

I meant that swiotlb doesn't need to handle ZONE_DMA. It handles only
devices that can handle ZONE_DMA32.


> > I have a half-baked patch for it. I'll send it later.
> 
> The problem are still the *_map users which usually cannot sleep,
> and then it's difficult to grow.

Why we can't use GFP_NOWAIT?

My approach is starting with small (like 4MB) and increasing io_tbl by
chunk such as 4MB.
