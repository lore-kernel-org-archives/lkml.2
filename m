Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0JLMiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:38:15 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:33066 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0JLMiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:38:14 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: =?iso-8859-1?Q?Penttil=E4_Mika?= <mika.penttila@ixonos.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Thread-Topic: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft
 offlining
Thread-Index: ActqClONcniQOTpST+6AZj80xmR29Q==
Date: Tue, 12 Oct 2010 12:38:10 +0000
Message-ID: <1A61D8EA6755AF458F06EA669A4EC81815FDA6FE@JKLMAIL02.ixonos.local>
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

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -564,6 +564,8 @@ static inline int free_pages_check(struct page *page)
>  		(page->mapping != NULL)  |
>  		(atomic_read(&page->_count) != 0) |
>  		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
> +		if (PageHWPoisonOnFree(page))
> +			hwpoison_page_on_free(page);

hwpoison_page_on_free() seems to be undefined when
CONFIG_HWPOISON_ON_FREE is not defined.

>  		bad_page(page);
>  		return 1;
>  	}

And of course PAGE_FLAGS_CHECK_AT_FREE should include pahehwpoisononfree this to be effective

--Mika


