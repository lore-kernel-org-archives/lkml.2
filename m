Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0HSQ46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:56:58 -0400
Received: from khc.piap.pl ([195.187.100.11]:46296 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab0HSQ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:56:56 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
References: <20100813215413.GA21607@n2100.arm.linux.org.uk>
	<20100814181306U.fujita.tomonori@lab.ntt.co.jp>
	<m3vd7agmqa.fsf@intrepid.localdomain>
	<20100819175024W.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 19 Aug 2010 18:56:53 +0200
In-Reply-To: <20100819175024W.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Thu, 19 Aug 2010 17:51:51 +0900")
Message-ID: <m34oeqsfqi.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

>> > +++ b/arch/arm/mm/dma-mapping.c
>> > @@ -77,6 +77,11 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
>> >  	if (mask < 0xffffffffULL)
>> >  		gfp |= GFP_DMA;
>> >  
>> > +#ifdef CONFIG_DMABOUNCE
>> > +	if (dev->archdata.dmabounce)
>> > +		gfp |= GFP_DMA;
>> > +#endif
>> > +
>> >  	page = alloc_pages(gfp, order);
>> >  	if (!page)
>> >  		return NULL;

> I'll re-send the patch in the proper format. Can you send it to
> mainline for 2.6.36?

Guess that's a question for Russell.
-- 
Krzysztof Halasa
