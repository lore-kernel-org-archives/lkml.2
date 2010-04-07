Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab0DGTa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 15:30:26 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:21710 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0DGTaZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 15:30:25 -0400
Date: Wed, 7 Apr 2010 15:28:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [LKML] Re: [PATCH] swiotlb v0.6: seperation of
	physical/virtual address translation
Message-ID: <20100407192821.GB5040@phenom.dumpdata.com>
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com> <20100405110317R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405110317R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0203.4BBCDD11.00A2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since the last posting I've:
> >  - Made the exported functions/variables have the 'swiotlb_bk' prefix instead
> >    of the 'do_[map|unmap]*' and 'io_tlb_*' combination.
> 
> Why can't we use more simpler names such as 'swiotlb_tbl_index'?

Much better. I was trying to come up with a name and the one I came up
with was 'bookkeeping', which I shortned to 'bk'. But 'tbl'
sounds better.

> Why do we need to add the prefix to static things like
> 'swiotlb_bk_list', 'swiotlb_bk_index', etc? Please let them alone.

Yup. Removed.
> > I had not addressed the question of removing the 'overflow' buffer. There are over
> > ~300 instances of the the DMA operations not being checked which plan on addressing
> > in a seperate set of patches that will slowly roll out the checks and then
> > finally the removal of the 'overflow' buffer.
> 
> Except for swiotlb, no IOMMU implementations has the mechanism of

I believe the GART one does it too. I think the overflow points to the
first page of the GART address and has logic to remind the user that danger
is immenient.

> overflow buffer. So drivers that don't check a DMA mapping error are
> broken anyway. Also the size of the overflow is 32K by default. We
> often see larger request than that. Even with the overflow mechanism,
> we see data corruption anyway.
