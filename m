Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0CWSPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:15:00 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44103 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab0CWSO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:14:57 -0400
Date: Wed, 24 Mar 2010 03:13:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region struct
Message-ID: <20100323181345.GA1891@linux-sh.org>
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org> <1269333587-1866-5-git-send-email-yinghai@kernel.org> <4BA899C2.8020208@kernel.org> <20100323104241.GA1189@elte.hu> <20100323131839.GA31552@linux-sh.org> <4BA8F7BD.20401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA8F7BD.20401@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:17:49AM -0700, Yinghai Lu wrote:
> On 03/23/2010 06:18 AM, Paul Mundt wrote:
> > On Tue, Mar 23, 2010 at 11:42:41AM +0100, Ingo Molnar wrote:
> >> also, i'd suggest to shorten region_array_size to region_size (we know it's an 
> >> array), so it would become:
> >>
> >> 	lmb.memory.region	 = lmb_memory_region;
> >> 	lmb.memory.region_size	 = ARRAY_SIZE(lmb_memory_region);
> >>
> > I don't mean to be pedantic, but the LMB code already has a lot of
> > region.size references so region_size looks a bit awkward. All of the
> > accessors in linux/lmb.h use region_nr as the array index, so perhaps
> > nr_regions would be less ambiguous.
> 
> @@ -26,7 +26,8 @@ struct lmb_property {
>  struct lmb_region {
>  	unsigned long cnt;
>  	u64 size;
> -	struct lmb_property region[MAX_LMB_REGIONS+1];
> +	struct lmb_property *region;
> +	unsigned long region_array_size;
>  };
> 
> cnt is number of slots used.
> size is memory size
> 
I'm fully aware of what each of these things are, and I have no idea what
any of that has to do with the point I raised above.

> can we use rgn_sz for region array size?
> 
No.
