Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab0DMEbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:31:36 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46781 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0DMEbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:31:34 -0400
Message-ID: <4BC3F317.7030702@oracle.com>
Date: Mon, 12 Apr 2010 21:29:11 -0700
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
Subject: Re: [PATCH 07/39] lmb: Add lmb_find_area()
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-8-git-send-email-yinghai@kernel.org> <1271131543.13059.53.camel@pasglop>
In-Reply-To: <1271131543.13059.53.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC3F37F.0032:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 09:05 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
>> It will try find area according with size/align in specified range (start, end).
>>
>> lmb_find_area() will honor goal/limit.
>>
>> also make it more easy for x86 to use lmb.
>> x86 early_res is using find/reserve pattern instead of alloc.
>>
>> When we need temporaray buff for range array etc for range work, if We are using
>> lmb_alloc(), We will need to add some post fix code for buffer that is used
>> by range array, because it is in the lmb.reserved already. and have to call
>> extra lmb_free().
>>
>> -v2: Change name to lmb_find_area() according to Michael Ellerman
>> -v3: Add generic weak version __lmb_find_area()
> 
> Haven't you noticed there's already way too many functions walking the
> LMBs ? :-)

x86 is using original lmb_reserve, lmb_free(), but have own version lmb_find_area(), and it will be dropped after
more testing of generic version of lmb_find_area()

> 
> I think the ones doing nid alloc could/should be also rewritten to use
> one single low level __lmb_find_* no ?

that nid_alloc() only has one user (sparc64).

maybe could be replaced by lmd_find_area_node(), but need to make sure early_node_map[] is filled at first.

Thanks

Yinghai
