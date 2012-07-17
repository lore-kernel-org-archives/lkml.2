Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2GQS1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:27:35 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:14914 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2GQS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:27:31 -0400
Message-ID: <1342549647.2539.29.camel@lorien2>
Subject: Re: [PATCH RFC] swiotlb: Disable swiotlb overflow support when
 CONFIG_ISA is enabled
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com, shuahkhan@gmail.com
Date: Tue, 17 Jul 2012 12:27:27 -0600
In-Reply-To: <20120716160119.GE13540@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
	 <20120709202505.GA9541@phenom.dumpdata.com>
	 <1341939307.2502.34.camel@lorien2>
	 <20120710173211.GB6868@phenom.dumpdata.com>
	 <1342109870.2576.23.camel@lorien2>
	 <20120716144536.GA552@phenom.dumpdata.com>
	 <1342453700.2949.6.camel@lorien2>
	 <20120716160119.GE13540@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 12:01 -0400, Konrad Rzeszutek Wilk wrote:

> > > The first goal is to figure out which of the drivers aren't doing this
> > > properly. This should be possible by just grepping for 'dma_map' and 
> > > seeing which ones don't do the 'dma_check' right after.
> > 

I did cscope searches two different ways on linux-next July 12th git

map_page - in this case I looked at all of the dma_ops.map_page() calls
to see if they are followed by dma_mapping_error() calls. Found the
following cases that don't check map_page() return value.

arch/powerpc/platforms/cell/iommu.c - dma_fixed_map_page()
drivers/net/ethernet/sun/niu.c - niu_rbr_add_page()
net/sunrpc/xprtrdma/svc_rdma_sendto.c - dma_map_xdr()

dma_map - in this case again I looked for calls to dma_map(). Found the
following cases where return isn't checked:

drivers/atm/fore200e.c
drivers/isdn/hardware/eicon/di.c

I am somewhat surprised to find only a few cases. Hoping I covered all
the bases, can you think of anything else I should look for before
concluding these are the cases that need fixing?

-- Shuah

