Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1JNG4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:56:07 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25126 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1JNG4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:56:05 -0400
X-IronPort-AV: E=Sophos;i="4.69,344,1315180800"; 
   d="scan'208";a="8387800"
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20111013142201.355f9afc.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com>
	 <20111013.163708.1319779926961023813.davem@davemloft.net>
	 <alpine.DEB.2.00.1110131348310.24853@chino.kir.corp.google.com>
	 <20111013.165148.64222593458932960.davem@davemloft.net>
	 <20111013142201.355f9afc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 14 Oct 2011 07:56:02 +0100
Message-ID: <1318575363.11016.8.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 22:22 +0100, Andrew Morton wrote:
> Looks OK to me.  I'm surprised we don't already have such a thing.
> 
> Review comments:
> 
> 
> > +struct page_frag {
> > +	struct page *page;
> > +#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
> 
> It does add risk that people will add compile warnings and bugs by
> failing to consider or test the other case.
>
> We could reduce that risk by doing
> 
>    #if (PAGE_SIZE >= 65536)
> 
> but then the 32-bit version would hardly ever be tested at all.

Indeed. The first variant has the benefit that most 32-bit arches will
test one case and most 64-bit ones the other.

Perhaps the need to keep this struct small is not so acute as it is for
the skb_frag_t I nicked it from and just using __u32 unconditionally is
sufficient?

> 
> > +	__u32 page_offset;
> 
> I suggest this be called simply "offset".

ACK.

Thanks,

Ian.


