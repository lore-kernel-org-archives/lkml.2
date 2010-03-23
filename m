Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0CWSIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:08:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab0CWSIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:08:37 -0400
Date: Tue, 23 Mar 2010 19:08:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region
 struct
Message-ID: <20100323180823.GA6088@elte.hu>
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org>
 <1269333587-1866-5-git-send-email-yinghai@kernel.org>
 <4BA899C2.8020208@kernel.org>
 <alpine.LFD.2.00.1003231528100.3147@localhost.localdomain>
 <4BA8FC9E.1050806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA8FC9E.1050806@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 03/23/2010 08:07 AM, Thomas Gleixner wrote:
> > On Tue, 23 Mar 2010, Yinghai Lu wrote:
> > 
> >>
> >> lmb_init() connect them back.
> >>
> >> also add region_array_size in lmb_region to tack the region array size.
> >>
> >> -v3: seperate lmb core change to seperated patch
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  include/linux/lmb.h |    5 ++++-
> >>  lib/lmb.c           |   11 ++++++++++-
> >>  2 files changed, 14 insertions(+), 2 deletions(-)
> >>
> >> Index: linux-2.6/include/linux/lmb.h
> >> ===================================================================
> >> --- linux-2.6.orig/include/linux/lmb.h
> >> +++ linux-2.6/include/linux/lmb.h
> >> @@ -26,7 +26,8 @@ struct lmb_property {
> >>  struct lmb_region {
> >>  	unsigned long cnt;
> >>  	u64 size;
> >> -	struct lmb_property region[MAX_LMB_REGIONS+1];
> >> +	struct lmb_property *region;
> >> +	unsigned long region_array_size;
> >>  };
> >>  
> >>  struct lmb {
> >> @@ -37,6 +38,8 @@ struct lmb {
> >>  };
> >>  
> >>  extern struct lmb lmb;
> >> +extern struct lmb_property lmb_memory_region[MAX_LMB_REGIONS + 1];
> >> +extern struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS + 1];
> > 
> > Is there a reason why this needs to be exported ?
> > 

> lmb_reserved_region is used in 
> kernel/early_res.c::__check_and_double_early_res/subtract_early_res/early_res_to_bootmem
> 
> later if those functions are moved lmb.c, we can make lmb_reserved_region to 
> be static
> 
> same thing to lmb_memory_region, that will be used by add_lmb_memory() 
> later.

I would strongly suggest for you to send the next (-v4) version to lkml only 
if it's 100% clean and complete in every known regard (with a good splitup and 
explanations in every commit), so that people dont repeat review or review an 
unclean aspect aspect that will go away in a next iteration.

Thanks,

	Ingo
