Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0JLOXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:23:22 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:8600 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0JLOXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:23:21 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz1432Nzz1202hzzz2fh2a8h)
From: =?iso-8859-1?Q?Penttil=E4_Mika?= <mika.penttila@ixonos.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Thread-Topic: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Thread-Index: AQHLahbKqxTcjRLBlUSEihs9tRH1LZM9XW3g
Date: Tue, 12 Oct 2010 14:23:15 +0000
Message-ID: <1A61D8EA6755AF458F06EA669A4EC81815FDA736@JKLMAIL02.ixonos.local>
References: <1A61D8EA6755AF458F06EA669A4EC81815FDA6FE@JKLMAIL02.ixonos.local>
 <8762x733qn.fsf@basil.nowhere.org>
In-Reply-To: <8762x733qn.fsf@basil.nowhere.org>
Accept-Language: en-US, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.31]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Reverse-DNS: po02.ixonos.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -564,6 +564,8 @@ static inline int free_pages_check(struct page
> *page)
> >>  		(page->mapping != NULL)  |
> >>  		(atomic_read(&page->_count) != 0) |
> >>  		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
> >> +		if (PageHWPoisonOnFree(page))
> >> +			hwpoison_page_on_free(page);
> >
> > hwpoison_page_on_free() seems to be undefined when
> > CONFIG_HWPOISON_ON_FREE is not defined.
> 
> The optimizer takes care of that.
> 
> >
> >>  		bad_page(page);
> >>  		return 1;
> >>  	}
> >
> > And of course PAGE_FLAGS_CHECK_AT_FREE should include
> > pahehwpoisononfree this to be effective
> 
> It is of course (__PG_HWPOISON_ON_FREE)
> 
Yes but it's not included in PAGE_FLAGS_CHECK_AT_FREE, if  I'm not missing something

--Mika


