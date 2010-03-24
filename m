Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0CXEqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:46:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:48768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab0CXEqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:46:16 -0400
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region
 struct
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100323104241.GA1189@elte.hu>
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org>
	 <1269333587-1866-5-git-send-email-yinghai@kernel.org>
	 <4BA899C2.8020208@kernel.org>  <20100323104241.GA1189@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 15:45:55 +1100
Message-ID: <1269405955.8599.156.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 11:42 +0100, Ingo Molnar wrote:
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

I dislike those arrays anyways. See my other message about turning them
into lists, which would get rid of capacity constraints completely. What
do you think ?

Cheers,
Ben.


