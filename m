Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0EQGLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:11:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63363 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQGLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:11:02 -0400
Message-ID: <4BF0DD98.1090904@oracle.com>
Date: Sun, 16 May 2010 23:09:28 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/37] lmb: Add lmb_find_area()
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>	 <1273866363-14249-8-git-send-email-yinghai@kernel.org>	 <1273876749.21352.645.camel@pasglop>  <4BEDD7D4.90002@oracle.com> <1274057329.21352.709.camel@pasglop>
In-Reply-To: <1274057329.21352.709.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BF0DDDF.0193:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 05:48 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2010-05-14 at 16:08 -0700, Yinghai wrote:
>> how about
>> lmb_reserve_area  ==> lmb_reserve_range
>> lmb_free_area  ==> lmb_free_range
> 
> I completely fail to see why you still need those two. They are exactly
> the same thing as lmb_reserve() and lmb_free(), just with a slightly
> different prototype.
> 
>> or leave them that way, later replace them lmb_reserve and lmb_free
>> one by one?
> 
> Nah, if you have some use of the wrappers to ease the transition from
> the existing x86 code, then just make up a couple of inline wrappers
> somewhere inside the x86 code. You may not even want to call it
> lmb_* at all... 

can you move asm/lmb.h down in linux/lmb.h ?

so I can put the inline wrapper in arch/x86/include/asm/lmb.h.

> 
> But here, I'll let Thomas and Peter decide what to do, it's really
> x86 stuff at this stage. I don't want to see two subtlely different
> APIs at the LMB level doing the same thing.
> 
> Cheers,
> Ben.
> 
> 

