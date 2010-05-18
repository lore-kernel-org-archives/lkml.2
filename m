Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0ERD24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:28:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:53107 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0ERD2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:28:54 -0400
Date: Tue, 18 May 2010 12:28:13 +0900
To: albert_herranz@yahoo.es
Cc: konrad.wilk@oracle.com, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions
 visible in the header file.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4BEB884B.7030402@yahoo.es>
References: <4BE9A989.5020808@yahoo.es>
	<20100511193918.GA4166@phenom.dumpdata.com>
	<4BEB884B.7030402@yahoo.es>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100518123010G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 18 May 2010 12:28:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 07:04:11 +0200
Albert Herranz <albert_herranz@yahoo.es> wrote:

> Konrad Rzeszutek Wilk wrote:
> > So these two patches (one to replace the PATCH 1/6 and the other to
> > replace this one), would work then:
> > 
> > I've put the whole tree at:
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8.1
> > 
> 
> The whole series work fine on the Wii 32-bit PowerPC platform (used to implement the MEM2 DMA facility needed by its EHCI controller).
> 
> Tested-by: Albert Herranz <albert_herranz@yahoo.es>

I know that you decrease the swiotlb size from 64MB (default) to 1MB,
however, pre-allocating 1MB is too wasteful to Wii?

Wii's EHCI controller connects to storage devices? If not, what you
need is the facility to do bouncing with dynamically allocated memory
such as the network stack, the block layer and
arm/arm/common/dmabounce.c

I think that we should have the common facility to do such.
