Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1IPSvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:51:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:36591 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1IPSvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:51:40 -0400
Date: Sat, 17 Sep 2011 03:51:13 +0900
To: benh@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, nacc@us.ibm.com, miltonm@bga.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH 2/4] dma-mapping: add get_required_mask if arch
 overrides default
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1314855311.4145.8.camel@pasglop>
References: <1308942325-4813-3-git-send-email-nacc@us.ibm.com>
	<20110629171304B.fujita.tomonori@lab.ntt.co.jp>
	<1314855311.4145.8.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110917034122J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 17 Sep 2011 03:51:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply,

On Thu, 01 Sep 2011 15:35:11 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2011-06-29 at 17:19 +0900, FUJITA Tomonori wrote:
> > On Fri, 24 Jun 2011 12:05:23 -0700
> > Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> > 
> > > From: Milton Miller <miltonm@bga.com>
> > > 
> > > If an architecture sets ARCH_HAS_DMA_GET_REQUIRED_MASK and has settable
> > > dma_map_ops, the required mask may change by the ops implementation.
> > > For example, a system that always has an mmu inline may only require 32
> > > bits while a swiotlb would desire bits to cover all of memory.
> > > 
> > > Therefore add the field if the architecture does not use the generic
> > > definition of dma_get_required_mask. The first use will by by powerpc.
> > > Note that this does add some dependency on the order in which files are
> > > visible here.
> 
>  .../...
> 
> > If you add get_required_mask to dma_map_ops, we should clean up ia64
> > too and implement the generic proper version in
> > dma-mapping-common.h. Then we kill ARCH_HAS_DMA_GET_REQUIRED_MASK
> > ifdef hack. Otherwise, I don't think it makes sense to add this to
> > dma_map_ops.
> 
> In the meantime, can I have an ack so I can include this along with the
> rest of Milton's patches ? It's been around for a while now :-)

Sure, we can clean up this later.

Thanks,



