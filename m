Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0C2QyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:54:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:56198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0C2QyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:54:22 -0400
Message-ID: <4BB0DAC2.3000805@kernel.org>
Date: Mon, 29 Mar 2010 09:52:18 -0700
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
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org> <1269865331.24620.44.camel@concordia>
In-Reply-To: <1269865331.24620.44.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 05:22 AM, Michael Ellerman wrote:
> On Sun, 2010-03-28 at 19:42 -0700, Yinghai Lu wrote:
>> the new lmb could be used to early_res in x86.
>>
>> Suggested by: David, Ben, and Thomas
>>
>> First three patches should go into 2.6.34
>>
>> -v6: change sequence as requested by Thomas
>> -v7: seperate them to more patches
>> -v8: add boundary checking to make sure not free partial page.
>> -v9: use lmb_debug to control print out of reserve_lmb.
>>      add e820 clean up, and e820 become __initdata
> 
> Bike shedding perhaps, but can you maintain the naming convention, ie.
> lmb_xxx() rather than xxx_lmb(). Neither is necessarily better, but all
> the existing functions use the lmb_xxx() style.
> 

so you want

find_lmb_area ==> lmb_find_area
reserve_lmb ==> lmb_reserve
free_lmb ==> lmb_free

first one is ok, 

but next two we already have lmb_reserved and lmb_free without checking and increasing the size of region array.

should i use 
lmb_reserve_with_check?

thanks

yinghai

