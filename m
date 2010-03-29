Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0C2WnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:43:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:59224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0C2WnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:43:20 -0400
Message-ID: <4BB12C8F.30802@kernel.org>
Date: Mon, 29 Mar 2010 15:41:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -v9 00/31] use lmb with x86
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269865331.24620.44.camel@concordia>  <4BB0DAC2.3000805@kernel.org>	 <1269900605.2286.2.camel@concordia>  <4BB126F6.8020805@kernel.org> <1269901944.2286.18.camel@concordia>
In-Reply-To: <1269901944.2286.18.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 03:32 PM, Michael Ellerman wrote:
>>
>> I want to keep the affects to other lmb users to minium at first.
> 
> That's a good plan, but I don't think this is the nicest way to do it.
> 
Too much to be test. so better to keep less impact to current lmb users.
>> and we can merge those functions later.
>>
>> or you insist on merging them in this patchset?
> 
> No I don't insist.
> 
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

dynamic region array for lmb.memory and lmb.reserved, actually is only need when plan to use
lmb to replace bootmem code.

Thanks

Yinghai
