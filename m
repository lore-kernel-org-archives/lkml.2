Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0ENIOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:14:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:56206 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab0ENIOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:14:05 -0400
Subject: Re: [PATCH 04/35] lmb: Add lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECECF4.4070205@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-5-git-send-email-yinghai@kernel.org>
	 <1273803410.21352.361.camel@pasglop>  <4BECECF4.4070205@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:12:06 +1000
Message-ID: <1273824726.21352.582.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:25 -0700, Yinghai wrote:
> >> +u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> >> +                    u64 size, u64 align);
> >> +u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
> > 
> > See my comments about sorting out the return from that function.
> > 
> > Also, I don't understand the need for that __ version. It looks like
> > something you should keep inside x86, I don't see the need for it in
> the
> > generic LMB code, since it just does trivial cropping of the
> arguments.
> 
> otherwise need to export lmb_find_base() and LMB_ERROR

Well, then export lmb_find_base(), and just sanitize the result codes
over all LMB. That's not -that- hard, it's not like there were gazillion
of users yet. I don't have time now to do that myself before monday.

> yes. but need that to keep switch from early_res/nobootmem to
> lmb/nobootmem smooth.
> 
> will clean it after early_res is replaced.

Then make it inline inside the x86 stuff. But really, you should cleanup
that result code. It's something on my TODO list for lmb that I haven't
had a chance to do yet, so please look at that or wait til next week so
I do it myself.

Cheers,
Ben.


