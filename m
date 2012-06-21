Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2FUMin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:38:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43401 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab2FUMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:38:36 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-84-4fe315ca1279
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Krishna Reddy'" <vdumpa@nvidia.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Hiroshi Doyu'" <hdoyu@nvidia.com>,
        "'Subash Patel'" <subashrp@gmail.com>,
        "'KOSAKI Motohiro'" <kosaki.motohiro@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <1339585306-7147-1-git-send-email-m.szyprowski@samsung.com>
 <1339585306-7147-3-git-send-email-m.szyprowski@samsung.com>
 <4FE2DCE7.80102@kernel.org>
In-reply-to: <4FE2DCE7.80102@kernel.org>
Subject: RE: [PATCHv3 2/3] mm: vmalloc: add VM_DMA flag to indicate areas used
 by dma-mapping framework
Date: Thu, 21 Jun 2012 14:38:15 +0200
Organization: SPRC
Message-id: <020601cd4faa$bfbad6e0$3f3084a0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1PiNYdDX0zjv8OR4ek3hQHSBGq0AAIUHzA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd1Too/9DX62qFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M629WMhbsFql40z6LqYGxW6CLkYNDQsBEYtbXui5GTiBTTOLC
	vfVsXYxcHEICixgl7kx5yQrhzGKSWHnlLxNIFZuAoUTX2y42EFtEQE1i3cEXLCBFzAI7WCTO
	PpzODNGxmFFi/ududpAqTgENif5XbawgtrBApsS5dfdZQGwWAVWJ9deesoGcwS8gJDFxlgJI
	mFfAReLV353sELagxI/J91hASpgF1CWmTMkFCTMLyEtsXvOWGeIBdYlHf3UhzjGSmLZgMhNE
	iYjE3YbnrBMYhWchGTQLYdAsJINmIelYwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	uJ9J72Bc1WBxiFGAg1GJh9ed7bG/EGtiWXFl7iFGCQ5mJRHeU48e+QvxpiRWVqUW5ccXleak
	Fh9ilOZgURLnbbK+4C8kkJ5YkpqdmlqQWgSTZeLglGpgjJne7cbD5jDha8TZ25MnpHOdfmtm
	yM7U5cfh//jsov5Pfxv+83CtX8g2lyk3Y5W75xqxBblH9zfm67WtuyIbWpN55ZfO6dJIkyL+
	fel5aX83sta6xc+Otf1U+XY7M/s6v+/b5LqXqbEHbfl1+Pl/G6uaeK1VU6uNuwOK4/fx2aU9
	WbFlpcAqJZbijERDLeai4kQAWT9U7GoCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, June 21, 2012 10:36 AM Minchan Kim wrote:

> On 06/13/2012 08:01 PM, Marek Szyprowski wrote:
> 
> > Add new type of vm_area intented to be used for mappings created by
> > dma-mapping framework.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  include/linux/vmalloc.h |    1 +
> >  mm/vmalloc.c            |    3 +++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > index 2e28f4d..e725b7b 100644
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -14,6 +14,7 @@ struct vm_area_struct;		/* vma defining user mapping in
> mm_types.h */
> >  #define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
> >  #define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
> >  #define VM_UNLIST	0x00000020	/* vm_struct is not listed in vmlist */
> > +#define VM_DMA		0x00000040	/* used by dma-mapping framework */
> >  /* bits [20..32] reserved for arch specific ioremap internals */
> >
> >  /*
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 11308f0..e04d59b 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2575,6 +2575,9 @@ static int s_show(struct seq_file *m, void *p)
> >  	if (v->flags & VM_IOREMAP)
> >  		seq_printf(m, " ioremap");
> >
> > +	if (v->flags & VM_DMA)
> > +		seq_printf(m, " dma");
> > +
> >  	if (v->flags & VM_ALLOC)
> >  		seq_printf(m, " vmalloc");
> >
> 
> 
> I still don't make sure that we should add new type for only ARM arch.
> I remember you said "It would be used for other architectures once we add" and
> Paul said he has a plan for SH. So at least, you should add such comment in changelog
> for persuading grumpy maintainers. :)
> 
> Frankly speaking, I could add my Reviewed-by but I think it wouldn't carry much weight
> because code is very tiny so you need Acked-by rather than Reviewed-by.
> IMHO, This problem is the thing only maintainer should decide.
> So I will toss the decision to akpm. Ccing akpm.(Ccing KOSAKI because he had a concern about
> this).
> 
> If anyone have a question to me, I'm Acked-by iff other architecture will use it.

Ok, if this flag is so controversial, I can change it to arch specific VM flag and utilize
'bits [20..32] reserved for arch specific ioremap internals'. Later, when other architectures 
start using similar flag, one can unify them and add such generic flag.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


