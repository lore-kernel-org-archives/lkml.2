Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab0ENXLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:11:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55276 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0ENXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:11:31 -0400
Message-ID: <4BEDD7D4.90002@oracle.com>
Date: Fri, 14 May 2010 16:08:04 -0700
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
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>	 <1273866363-14249-8-git-send-email-yinghai@kernel.org> <1273876749.21352.645.camel@pasglop>
In-Reply-To: <1273876749.21352.645.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BEDD88D.0130:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 03:39 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2010-05-14 at 12:45 -0700, Yinghai Lu wrote:
>> it is a wrapper for lmb_find_base
>>
>> make it more easy for x86 to use lmb. ( rebase )
>> x86 early_res is using find/reserve pattern instead of alloc.
>>
>> keep it in weak version, so later We can use x86 own version if needed.
>> also We need it in lib/lmb.c, so one called mm/page_alloc.c could get compiled
> 
> I seem to have told you that I didn't want to have that thing in the
> core :-)
> 
> You keep adding those "wrappers" which basically just do prototype
> adaptation and in this case a bit of cropping, with a name that is
> utterly confusing as to what their intent is.
> 
> I might have accepted that one if you had called it something like
> lmb_find_in_range() which at least -means- something.

thanks. will use sed to replace them.

lmb_find_area ==> lmb_find_in_range()

how about
lmb_reserve_area  ==> lmb_reserve_range
lmb_free_area  ==> lmb_free_range
or leave them that way, later replace them lmb_reserve and lmb_free one by one?

YH
