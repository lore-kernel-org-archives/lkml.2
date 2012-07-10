Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2GJQzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:55:14 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3319 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2GJQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:55:12 -0400
Message-ID: <1341939307.2502.34.camel@lorien2>
Subject: Re: [PATCH RFC] swiotlb: Remove SWIOTLB overflow buffer support
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com, shuahkhan@gmail.com
Date: Tue, 10 Jul 2012 10:55:07 -0600
In-Reply-To: <20120709202505.GA9541@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
	 <20120709202505.GA9541@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 16:25 -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 06, 2012 at 05:06:12PM -0600, Shuah Khan wrote:
> > Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
> > (a value of zero) to make it consistent with iommu implementation
> > on Intel, AMD, and swiotlb-xen.
> 
> While this is a good forward step and this needs to be done eventually,
> you should first send out patches for the drivers that don't check
> for the DMA_ERROR_CODE when doing mapping. In other words for the
> drivers that map but don't call dma_mapping_error to check.
> 
> When that is fixed and *all the drivers that don't call dma_mapping_error
> are fixed, then this patch makes sense.

The challenge will be catching all the drivers and have confidence that
all of them are covered. I will start looking into this to get a feel
for how many drivers needs fixing.

Also, isn't this problem today with other iommu implementations? All of
the other iommu implementation don't have support for overflow buffers?

-- Shuah



