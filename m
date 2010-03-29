Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0C2XfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:35:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:36743 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0C2XfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:35:13 -0400
Subject: Re: [PATCH -v9 00/31] use lmb with x86
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1269901944.2286.18.camel@concordia>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269865331.24620.44.camel@concordia>  <4BB0DAC2.3000805@kernel.org>
	 <1269900605.2286.2.camel@concordia>  <4BB126F6.8020805@kernel.org>
	 <1269901944.2286.18.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 10:33:47 +1100
Message-ID: <1269905627.7101.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 09:32 +1100, Michael Ellerman wrote:
> I _suggest_ that if we want to avoid affecting existing lmb users, then
> the checking logic should go into the existing API, but be #ifdef'ed for
> now - eg. CONFIG_DYNAMIC_LMB or something. That way you avoid affecting
> existing users (more or less), but you don't add a new API that you then
> have to remove later.
> 
> Having said that I don't think it really does affect existing users that
> much. We still have the statically defined region arrays, and they're
> still the same size, so sparc and powerpc should never need to resize,
> except on machines where we currently run out of space in the array
> anyway. 

We'll want the dynamic sizing if we switch bootmem to lmb (though last I
looked, that still needs sparsemem to be fixed as well as it still uses
bootmem). There's also some interest on ARM side I've heard.

I still have my evil plan to turn it into lists anyways, but we'll see
how that goes later. In any case, the doubling ability does the job for
now and yes, it should definitely be part of the core.

LMB should be able to use it's own storage to do the doubling. IE.
Always guarantee that you have at least 1 or 2 free entries in the
table, if you're going past that threshold, then use the remaining entry
to allocate a new table. Easy :-)

Cheers,
Ben.


