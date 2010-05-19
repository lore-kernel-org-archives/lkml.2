Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0ESDfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 23:35:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:42402 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0ESDfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 23:35:19 -0400
Date: Wed, 19 May 2010 12:34:18 +0900
To: albert_herranz@yahoo.es
Cc: fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       linux@arm.linux.org.uk
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions
 visible in the header file.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4BF2C5C1.2020807@yahoo.es>
References: <4BEB884B.7030402@yahoo.es>
	<20100518123010G.fujita.tomonori@lab.ntt.co.jp>
	<4BF2C5C1.2020807@yahoo.es>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100519123626P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 12:34:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 18:52:17 +0200
Albert Herranz <albert_herranz@yahoo.es> wrote:

> Hi,
> 
> On 05/18/2010 05:28 AM, FUJITA Tomonori wrote:
> >> The whole series work fine on the Wii 32-bit PowerPC platform (used to implement the MEM2 DMA facility needed by its EHCI controller).
> >>
> >> Tested-by: Albert Herranz <albert_herranz@yahoo.es>
> > 
> > I know that you decrease the swiotlb size from 64MB (default) to 1MB,
> > however, pre-allocating 1MB is too wasteful to Wii?
> > 
> 
> Every single KB counts on the Wii. It has just 24MB of MEM1 and 64MB of MEM2 (discontiguous memory ranges).
> I'm using 1MB for the SWIOTLB for now, but of course that can be further tweaked down.

You can decrease the swiotlb memory however you can't fix the root
problems of swiotlb:

- it needs pre-allocated memory
- it can't handle the out-of-pre-allocated memory situation.


> > Wii's EHCI controller connects to storage devices? If not, what you
> > need is the facility to do bouncing with dynamically allocated memory
> > such as the network stack, the block layer and
> > arm/arm/common/dmabounce.c
> > 
> 
> The two external USB ports in the Wii are part of an embedded EHCI controller (with its two OHCI companion controllers). You can connect whatever USB device you want to them.

I mean that Wii doesn't boot on the root device on the USB controller,
right?

> I posted (in the past) a patch series [1] in which I made the
> dmabounce code in the ARM architecture tree available to other
> architectures, and used that to implement the needed bouncing
> infrastructure.  But I was told then by Russell to use swiotlb
> instead [2].

I think that we need to modify swiotlb for embedded archs. Otherwise,
I don't think that swiotlb can replace arm's dmabounce.

Ok, I'll implement something like that.
