Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0CWNTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:19:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39561 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab0CWNTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:19:51 -0400
Date: Tue, 23 Mar 2010 22:18:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region struct
Message-ID: <20100323131839.GA31552@linux-sh.org>
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org> <1269333587-1866-5-git-send-email-yinghai@kernel.org> <4BA899C2.8020208@kernel.org> <20100323104241.GA1189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323104241.GA1189@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:42:41AM +0100, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> >  void __init lmb_init(void)
> >  {
> > +	lmb.memory.region   = lmb_memory_region;
> > +	lmb.memory.region_array_size   = ARRAY_SIZE(lmb_memory_region);
> > +	lmb.reserved.region = lmb_reserved_region;
> > +	lmb.reserved.region_array_size = ARRAY_SIZE(lmb_reserved_region);
> > +
> 
> That's rather unreadable and has random whitespace noise.
> 
> Should be something like:
> 
> 	lmb.memory.region		= lmb_memory_region;
> 	lmb.memory.region_array_size	= ARRAY_SIZE(lmb_memory_region);
> 	lmb.reserved.region		= lmb_reserved_region;
> 	lmb.reserved.region_array_size	= ARRAY_SIZE(lmb_reserved_region);
> 
> also, i'd suggest to shorten region_array_size to region_size (we know it's an 
> array), so it would become:
> 
> 	lmb.memory.region	 = lmb_memory_region;
> 	lmb.memory.region_size	 = ARRAY_SIZE(lmb_memory_region);
> 
I don't mean to be pedantic, but the LMB code already has a lot of
region.size references so region_size looks a bit awkward. All of the
accessors in linux/lmb.h use region_nr as the array index, so perhaps
nr_regions would be less ambiguous.
