Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0EQAuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:50:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:33388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0EQAuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:50:35 -0400
Subject: Re: [PATCH 07/37] lmb: Add lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BEDD7D4.90002@oracle.com>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
	 <1273866363-14249-8-git-send-email-yinghai@kernel.org>
	 <1273876749.21352.645.camel@pasglop>  <4BEDD7D4.90002@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 10:48:49 +1000
Message-ID: <1274057329.21352.709.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 16:08 -0700, Yinghai wrote:
> how about
> lmb_reserve_area  ==> lmb_reserve_range
> lmb_free_area  ==> lmb_free_range

I completely fail to see why you still need those two. They are exactly
the same thing as lmb_reserve() and lmb_free(), just with a slightly
different prototype.

> or leave them that way, later replace them lmb_reserve and lmb_free
> one by one?

Nah, if you have some use of the wrappers to ease the transition from
the existing x86 code, then just make up a couple of inline wrappers
somewhere inside the x86 code. You may not even want to call it
lmb_* at all... 

But here, I'll let Thomas and Peter decide what to do, it's really
x86 stuff at this stage. I don't want to see two subtlely different
APIs at the LMB level doing the same thing.

Cheers,
Ben.


