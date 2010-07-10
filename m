Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0GJOyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 10:54:05 -0400
Received: from 8bytes.org ([88.198.83.132]:45204 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab0GJOyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 10:54:01 -0400
Date: Sat, 10 Jul 2010 16:54:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Andi Kleen <andi@firstfloor.org>, Daniel Walker <dwalker@codeaurora.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
Message-ID: <20100710145400.GB10080@8bytes.org>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com> <20100701193850.GB3594@basil.fritz.box> <4C2D0FF1.6010206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2D0FF1.6010206@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 03:00:17PM -0700, Zach Pfeffer wrote:
> Additionally, the current IOMMU interface does not allow users to
> associate one page table with multiple IOMMUs [...]

Thats not true. Multiple IOMMUs are completly handled by the IOMMU
drivers. In the case of the IOMMU-API backend drivers this also includes
the ability to use page-tables on multiple IOMMUs.

> Since the particular topology is run-time configurable all of these
> use-cases and more can be expressed without pushing the topology into
> the low-level IOMMU driver.

The IOMMU driver has to know about the topology anyway because it needs
to know which IOMMU it needs to program for a particular device.

> Already, there are ~20 different IOMMU map implementations in the
> kernel. Had the Linux kernel had the VCMM, many of those
> implementations could have leveraged the mapping and topology
> management of a VCMM, while focusing on a few key hardware specific
> functions (map this physical address, program the page table base
> register).

I partially agree here. All the IOMMU implementations in the Linux
kernel have a lot of functionality in common where code could be
shared. Work to share code has been done in the past by Fujita Tomonori
but there are more places to work on. I am just not sure if a new
front-end API is the right way to do this.

	Joerg

