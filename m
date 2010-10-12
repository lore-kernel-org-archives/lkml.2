Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0JLOa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:30:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0JLOa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:30:27 -0400
Date: Tue, 12 Oct 2010 16:30:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Penttil=E4?= Mika <mika.penttila@ixonos.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Message-ID: <20101012143022.GF20436@basil.fritz.box>
References: <1A61D8EA6755AF458F06EA669A4EC81815FDA6FE@JKLMAIL02.ixonos.local>
 <8762x733qn.fsf@basil.nowhere.org>
 <1A61D8EA6755AF458F06EA669A4EC81815FDA736@JKLMAIL02.ixonos.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1A61D8EA6755AF458F06EA669A4EC81815FDA736@JKLMAIL02.ixonos.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 02:23:15PM +0000, Penttilä Mika wrote:
> > >>  		bad_page(page);
> > >>  		return 1;
> > >>  	}
> > >
> > > And of course PAGE_FLAGS_CHECK_AT_FREE should include
> > > pahehwpoisononfree this to be effective
> > 
> > It is of course (__PG_HWPOISON_ON_FREE)
> > 
> Yes but it's not included in PAGE_FLAGS_CHECK_AT_FREE, if  I'm not missing something

#ifdef CONFIG_HWPOISON_ON_FREE
PAGEFLAG(HWPoisonOnFree, hwpoison_on_free)
TESTSCFLAG(HWPoisonOnFree, hwpoison_on_free)
#define __PG_HWPOISON_ON_FREE (1UL << PG_hwpoison_on_free)
#else
PAGEFLAG_FALSE(HWPoisonOnFree)
SETPAGEFLAG_NOOP(HWPoisonOnFree)
#define __PG_HWPOISON_ON_FREE 0
#endif

...

#define PAGE_FLAGS_CHECK_AT_FREE \
        (1 << PG_lru     | 1 << PG_locked    | \
         1 << PG_private | 1 << PG_private_2 | \
         1 << PG_buddy   | 1 << PG_writeback | 1 << PG_reserved | \
         1 << PG_slab    | 1 << PG_swapcache | 1 << PG_active | \
         1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON | \
         __PG_HWPOISON_ON_FREE)


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
