Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0DMF3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:29:06 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:22931 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0DMF3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:29:04 -0400
Message-ID: <4BC40074.6030604@oracle.com>
Date: Mon, 12 Apr 2010 22:26:12 -0700
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
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-8-git-send-email-yinghai@kernel.org>	 <1271131543.13059.53.camel@pasglop>  <4BC3F317.7030702@oracle.com> <1271135239.13059.69.camel@pasglop>
In-Reply-To: <1271135239.13059.69.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BC40108.009D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:07 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-04-12 at 21:29 -0700, Yinghai wrote:
>>
>>> Haven't you noticed there's already way too many functions walking
>> the
>>> LMBs ? :-)
>>
>> x86 is using original lmb_reserve, lmb_free(), but have own version
>> lmb_find_area(), and it will be dropped after
>> more testing of generic version of lmb_find_area()
> 
> Do -not- add no APIs that are meant to be dropped. They never are in
> practice. What I'm saying here is that the LMB code (including existing
> stuff) could use some factoring in this area.

current generic lmb_find_area() is allocating from high to low.
x86 32bit seems have problem with that.
in this patchset, it is fixed, but not sure if i missed sth.
so could remove x86 lmb_find_area after more test coverage.

> 
>>>
>>> I think the ones doing nid alloc could/should be also rewritten to
>> use
>>> one single low level __lmb_find_* no ?
>>
>> that nid_alloc() only has one user (sparc64).
>>
>> maybe could be replaced by lmd_find_area_node(), but need to make sure
>> early_node_map[] is filled at first.
> 
> How does it work today ? IE. Which ever mechanism is used that works I
> don't care but we shouldn't use 2 different ones.

x86 is only use find_area_early() with node area scope, David point that could have problem with cross node mem map.

YH 
