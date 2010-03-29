Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0C2Xbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:31:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:45356 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0C2Xbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:31:51 -0400
Subject: Re: [PATCH -v9 00/31] use lmb with x86
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB126F6.8020805@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269865331.24620.44.camel@concordia>  <4BB0DAC2.3000805@kernel.org>
	 <1269900605.2286.2.camel@concordia>  <4BB126F6.8020805@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 10:29:53 +1100
Message-ID: <1269905393.7101.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 15:17 -0700, Yinghai Lu wrote:
> > That was the point of my other mail. We now have two lmb APIs, one
> which
> > checks if the array will overflow and one which doesn't. That seems
> like
> > a bad idea. Having one called lmb_free() and one called free_lmb()
> is
> > definitely a bad idea, because it's completely non obvious which one
> > caters for overflow.
> 
> I want to keep the affects to other lmb users to minium at first.
> 
> and we can merge those functions later.
> 
> or you insist on merging them in this patchset?

As a separate patch sure, but you should really separate the patch
series that changes LMB from the one that moves x86 to it imho. It would
make things much clearer.

It would also allow you to spend some time properly -documenting- why
you need to change LMB the way you do, since it's non obvious for those
not familiar with x86 needs. I'm not objecting to the changes, I'm just
asking for much better documentation as to why they are needed and what
function they provide.

Cheers,
Ben.


