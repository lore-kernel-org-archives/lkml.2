Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0C2XdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:33:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:45377 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab0C2XdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:33:14 -0400
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1269901252.2286.11.camel@concordia>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>
	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>
	 <1269901252.2286.11.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 10:31:31 +1100
Message-ID: <1269905491.7101.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 09:20 +1100, Michael Ellerman wrote:
> 
> But that's my point. You shouldn't need to touch the existing API, and
> you shouldn't need to add a new parallel API. You should just be able to
> add the logic for doubling the array in the lmb core, and then everyone
> gets dynamically expandable lmb. I don't see any reason why we want to
> have two APIs.

Ack.

> > > It seems to me that rather than adding these "special" routines that
> > > check for enough space on the way in, instead you should be checking in
> > > lmb_add_region() - which is where AFAICS all allocs/frees/reserves
> > > eventually end up if they need to insert a new region.
> > 
> > later i prefer to replace lmb_alloc with find_lmb_area + reserve_lmb.
> 
> Why? The existing code has been working for years and is well tested? 

I still don't totally understand why he needs a find_lmb_area()
anyways. 

It might be justified ... or not. I just want it to be better
documented.

Cheers,
Ben.


