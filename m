Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1IAFfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:35:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:55931 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1IAFfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:35:43 -0400
Subject: Re: [PATCH 2/4] dma-mapping: add get_required_mask if arch
 overrides default
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nacc@us.ibm.com, miltonm@bga.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com
In-Reply-To: <20110629171304B.fujita.tomonori@lab.ntt.co.jp>
References: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
	 <1308942325-4813-3-git-send-email-nacc@us.ibm.com>
	 <20110629171304B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 15:35:11 +1000
Message-ID: <1314855311.4145.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 17:19 +0900, FUJITA Tomonori wrote:
> On Fri, 24 Jun 2011 12:05:23 -0700
> Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> 
> > From: Milton Miller <miltonm@bga.com>
> > 
> > If an architecture sets ARCH_HAS_DMA_GET_REQUIRED_MASK and has settable
> > dma_map_ops, the required mask may change by the ops implementation.
> > For example, a system that always has an mmu inline may only require 32
> > bits while a swiotlb would desire bits to cover all of memory.
> > 
> > Therefore add the field if the architecture does not use the generic
> > definition of dma_get_required_mask. The first use will by by powerpc.
> > Note that this does add some dependency on the order in which files are
> > visible here.

 .../...

> If you add get_required_mask to dma_map_ops, we should clean up ia64
> too and implement the generic proper version in
> dma-mapping-common.h. Then we kill ARCH_HAS_DMA_GET_REQUIRED_MASK
> ifdef hack. Otherwise, I don't think it makes sense to add this to
> dma_map_ops.

In the meantime, can I have an ack so I can include this along with the
rest of Milton's patches ? It's been around for a while now :-)

I'm a bit late for producing a powerpc-next (due to travelling).

Cheers,
Ben.


