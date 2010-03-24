Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0CXSUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:20:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:33819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0CXSUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:20:00 -0400
Message-ID: <4BAA5766.3020100@kernel.org>
Date: Wed, 24 Mar 2010 11:18:14 -0700
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
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4 00/08] use lmb with x86
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org>	 <20100324104844.GA896@elte.hu> <1269430868.2500.14.camel@concordia>
In-Reply-To: <1269430868.2500.14.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 04:41 AM, Michael Ellerman wrote:
> On Wed, 2010-03-24 at 11:48 +0100, Ingo Molnar wrote:
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> new early_res is lmb extension. and it could be used to replace bootmem.
>>
>> Why not do what we suggested: extend lmb.c to also offer the 
>> early_res-equivalent functionality, and remove kernel/early_res.c and move 
>> lib/lmb.c to mm/lmb.c?
>>
>> We dont want two facilities (early_res and lmb) really ...
> 
> Exactly. 
> 
> This series seems to leave us with kernel/early_res.c (which should
> never have moved out of arch/x86 AFAICS) - as well as using some of
> lmb.c.
the new version...
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=blob;f=kernel/early_res.c;h=a7933939b44ae1ccb72e30203031f5b742c88a3f;hb=c9115b0731084ec0c0e164456b7434ea61c2a67b

should be clean.

> 
> It doesn't compile on powerpc, because early_res.c is looking for
> find_fw_memmap_area() which is still under arch/x86.

it looks that you are looking at old version somehow.

please check
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=summary

> 
> And sprinkling CONFIG_NO_BOOTMEM everywhere is getting a bit gross. I
> notice that's already happened to mm/(bootmem|page_alloc).c but
> propagating it further is not nice.

for converting smoothly, before we remove bootmem core, we can keep it. and can compare bootmem and nobootmem side by side.

Thanks

Yinghai
