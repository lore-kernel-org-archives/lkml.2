Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1HWUpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:45:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39692 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1HWUpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:45:40 -0400
Message-ID: <4E541154.6090805@zytor.com>
Date: Tue, 23 Aug 2011 13:45:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org>
In-Reply-To: <4E540548.4080402@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 12:53 PM, Jeremy Fitzhardinge wrote:
> 
> Yes, that would ideal.  The closest you can get is asm goto(), but the
> syntax for that would be awful; something like:
> 
> #define cmpxchg_jump(ptr, old, new, fail)\
> 	asm goto (...)
> 
> 
> :
> :
> 
> again:
> 	old = *thingp;
> 	new = frobulate(old);
> 	cmpxchg_jump(thingp, old, new, again);
> 	/* worked */
> 
> Would this be useful enough?
> 

Actually there is a trick:

static inline bool ....
{
	asm goto(... yes);
no:
	return false;
yes:
	return true;
}

... which makes syntax a heckuva lot less awkward.

	-hpa
