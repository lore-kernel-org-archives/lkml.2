Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab0JLOdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:33:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:41900 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab0JLOdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:33:42 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432N98dNzz1202hzz8275bh8275dhz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: =?iso-8859-1?Q?Penttil=E4_Mika?= <mika.penttila@ixonos.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Thread-Topic: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Thread-Index: AQHLahbKqxTcjRLBlUSEihs9tRH1LZM9XW3g///QGwCAADLj8A==
Date: Tue, 12 Oct 2010 14:33:34 +0000
Message-ID: <1A61D8EA6755AF458F06EA669A4EC81815FDA750@JKLMAIL02.ixonos.local>
References: <1A61D8EA6755AF458F06EA669A4EC81815FDA6FE@JKLMAIL02.ixonos.local>
 <8762x733qn.fsf@basil.nowhere.org>
 <1A61D8EA6755AF458F06EA669A4EC81815FDA736@JKLMAIL02.ixonos.local>
 <20101012143022.GF20436@basil.fritz.box>
In-Reply-To: <20101012143022.GF20436@basil.fritz.box>
Accept-Language: en-US, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.31]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: po02.ixonos.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: 12. lokakuuta 2010 17:30
> To: Penttilä Mika
> Cc: Andi Kleen; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft
> offlining
> 
> On Tue, Oct 12, 2010 at 02:23:15PM +0000, Penttilä Mika wrote:
> > > >>  		bad_page(page);
> > > >>  		return 1;
> > > >>  	}
> > > >
> > > > And of course PAGE_FLAGS_CHECK_AT_FREE should include
> > > > pahehwpoisononfree this to be effective
> > >
> > > It is of course (__PG_HWPOISON_ON_FREE)
> > >
> > Yes but it's not included in PAGE_FLAGS_CHECK_AT_FREE, if  I'm not
> missing something
> 
> #ifdef CONFIG_HWPOISON_ON_FREE
> PAGEFLAG(HWPoisonOnFree, hwpoison_on_free)
> TESTSCFLAG(HWPoisonOnFree, hwpoison_on_free)
> #define __PG_HWPOISON_ON_FREE (1UL << PG_hwpoison_on_free)
> #else
> PAGEFLAG_FALSE(HWPoisonOnFree)
> SETPAGEFLAG_NOOP(HWPoisonOnFree)
> #define __PG_HWPOISON_ON_FREE 0
> #endif
> 
> ...
> 
> #define PAGE_FLAGS_CHECK_AT_FREE \
>         (1 << PG_lru     | 1 << PG_locked    | \
>          1 << PG_private | 1 << PG_private_2 | \
>          1 << PG_buddy   | 1 << PG_writeback | 1 << PG_reserved | \
>          1 << PG_slab    | 1 << PG_swapcache | 1 << PG_active | \
>          1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON | \
>          __PG_HWPOISON_ON_FREE)
> 
> 
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.



Sure, sorry for that, read the patch badly..

--Mika



