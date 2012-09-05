Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2IEOig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:38:36 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23810 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2IEOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:38:35 -0400
Message-ID: <1346855913.2589.10.camel@lorien2>
Subject: Re: [PATCH] swiotlb: add kernel error message to track iobtlb
 overflow buffer usage
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fujita.tomonori@lab.ntt.co.jp, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Wed, 05 Sep 2012 08:38:33 -0600
In-Reply-To: <20120904162804.baad7cc0.akpm@linux-foundation.org>
References: <1346460959.3393.3.camel@lorien2>
	 <20120904162804.baad7cc0.akpm@linux-foundation.org>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 16:28 -0700, Andrew Morton wrote:
> On Fri, 31 Aug 2012 18:55:59 -0600
> Shuah Khan <shuah.khan@hp.com> wrote:
> 
> > Add kernel error message to track iotlb overflow buffer triggers to understand
> > how often the overflow buffer gets used.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  lib/swiotlb.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index 45bc1f8..597d7b9 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -682,6 +682,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
> >  	if (!map) {
> >  		swiotlb_full(dev, size, dir, 1);
> >  		map = io_tlb_overflow_buffer;
> > +		dev_err(dev, "SWIOTLB is full. Mapping overflow buffer.\n");
> >  	}
> >  
> >  	dev_addr = swiotlb_virt_to_bus(dev, map);
> 
> hm.  I would view this as a developer-only debugging thing which
> shouldn't be present in production code.  Plus there's a potential that
> some poor person will have his logs flooded with this message.

Yes. I agree.
> 
> A more typical way of handling this would be to increment a stats
> counter, accessible in procfs or debugfs.
> 

Right. I will work on it. Maybe there is a way to combine this with
dma-debug dma mapping error tracking work I am doing - will look into.

-- Shuah


