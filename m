Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2GPPsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:48:24 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:13267 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2GPPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:48:22 -0400
Message-ID: <1342453700.2949.6.camel@lorien2>
Subject: Re: [PATCH RFC] swiotlb: Disable swiotlb overflow support when
 CONFIG_ISA is enabled
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com, shuahkhan@gmail.com
Date: Mon, 16 Jul 2012 09:48:20 -0600
In-Reply-To: <20120716144536.GA552@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
	 <20120709202505.GA9541@phenom.dumpdata.com>
	 <1341939307.2502.34.camel@lorien2>
	 <20120710173211.GB6868@phenom.dumpdata.com>
	 <1342109870.2576.23.camel@lorien2>
	 <20120716144536.GA552@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 10:45 -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 12, 2012 at 10:17:50AM -0600, Shuah Khan wrote:
> > Disable iotlb overflow support when CONFIG_ISA is enabled. This is the
> > first step towards removing overflow support, to be consistent with other
> > iommu implementations and return DMA_ERROR_CODE. This disabling step is
> > for finding drivers that don't call dma_mapping_error to check for errors
> > returned by the mapping interface. Once drivers are fixed overflow support
> > can be removed.
> 
> I think I explained myself poorly. We don't want to break old drivers.
> 
> If the old drivers expect this behavior (while they should be updated
> to check the DMA), we need to retain this behavior.
> 
> So I think the patch should be done the other way:
> 
> Disable IOTLB overflow when CONFIG_ISA is disabled.

That makes lot of sense :) I will redo the patch. It might be good to a
tunable to control enable/disable behavior. Even though support for this
new tunable "swiotlb_overflow" projected to be short lived, it will be
lot less painful to disable/enable as needed. Thought and comments?

> 
> But we also need to check whether there are other drivers
> that don't properly check the DMA address. And if so, add them
> to this list of must have enabled b/c you might be using this
> driver.

Sound good. Again having a tunable would help in this case as well.
> 
> The first goal is to figure out which of the drivers aren't doing this
> properly. This should be possible by just grepping for 'dma_map' and 
> seeing which ones don't do the 'dma_check' right after.

I started some research into this and will continue and provide an
update.

-- Shuah

