Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HVRJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 13:09:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32769 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1HVRJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 13:09:12 -0400
MIME-Version: 1.0
Message-ID: <cf3e6497-c77f-47eb-a35e-360ea68ade85@default>
Date: Mon, 22 Aug 2011 10:08:08 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: hannes@cmpxchg.org, jackdachef@gmail.com, hughd@google.com,
        jeremy@goop.org, npiggin@kernel.dk, linux-mm@kvack.org,
        akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, riel@redhat.com,
        ngupta@vflare.org, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure
 changes
References: <20110808204555.GA15850@ca-server1.us.oracle.com>
 <4E414320020000780005057E@nat28.tlf.novell.com><4E414320020000780005057E@nat28.tlf.novell.com>
 <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default
 4E4179D90200007800050676@nat28.tlf.novell.com>
In-Reply-To: <4E4179D90200007800050676@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E528D07.012E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@novell.com]
> Sent: Tuesday, August 09, 2011 10:18 AM
> To: Dan Magenheimer
> Cc: hannes@cmpxchg.org; jackdachef@gmail.com; hughd@google.com; jeremy@goop.org; npiggin@kernel.dk;
> linux-mm@kvack.org; akpm@linux-foundation.org; sjenning@linux.vnet.ibm.com; Chris Mason; Konrad Wilk;
> Kurt Hackel; riel@redhat.com; ngupta@vflare.org; linux-kernel@vger.kernel.org; matthew@wil.cx
> Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure changes
> 
> >>> On 09.08.11 at 17:03, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> >> > --- linux/include/linux/swap.h	2011-08-08 08:19:25.880690134 -0600
> >> > +++ frontswap/include/linux/swap.h	2011-08-08 08:59:03.952691415 -0600
> >> > @@ -194,6 +194,8 @@ struct swap_info_struct {
> >> >  	struct block_device *bdev;	/* swap device or bdev of swap file */
> >> >  	struct file *swap_file;		/* seldom referenced */
> >> >  	unsigned int old_block_size;	/* seldom referenced */
> >>
> >> #ifdef CONFIG_FRONTSWAP
> >>
> >> > +	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
> >> > +	unsigned int frontswap_pages;	/* frontswap pages in-use counter */
> >>
> >> #endif
> >>
> >> (to eliminate any overhead with that config option unset)
> >>
> >> Jan
> >
> > Hi Jan --
> >
> > Thanks for the review!
> >
> > As noted in the commit comment, if these structure elements are
> > not put inside an #ifdef CONFIG_FRONTSWAP, it becomes
> > unnecessary to clutter the core swap code with several ifdefs.
> > The cost is one pointer and one unsigned int per allocated
> > swap device (often no more than one swap device per system),
> > so the code clarity seemed more important than the tiny
> > additional runtime space cost.
> >
> > Do you disagree?
> 
> Not necessarily - I just know that in other similar occasions (partly
> internally to our company) I was asked to make sure turned off
> features would not leave *any* run time foot print whatsoever.
> 
> Jan

Hi Jan --

With two extra static inlines in frontswap.h (frontswap_map_get()
and frontswap_map_set(), I've managed to both avoid the extra swap struct
members for frontswap_map and frontswap_pages when CONFIG_FRONTSWAP is
disabled AND avoid the #ifdef CONFIG_FRONTSWAP clutter in swapfile.h.

I'll post a V7 soon... let me know what you think!

Thanks,
Dan
