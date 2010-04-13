Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab0DMFlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:41:24 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:54736 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0DMFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:41:22 -0400
Message-ID: <4BC40336.4030902@oracle.com>
Date: Mon, 12 Apr 2010 22:37:58 -0700
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
Subject: Re: [PATCH 18/39] lmb: Add lmb_reserve_area_overlap_ok()
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-19-git-send-email-yinghai@kernel.org>	 <1271132476.13059.66.camel@pasglop>  <4BC3F6C8.4020303@oracle.com> <1271135450.13059.72.camel@pasglop>
In-Reply-To: <1271135450.13059.72.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC403E5.0157:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:10 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-04-12 at 21:44 -0700, Yinghai wrote:
> 
>> that is only for some special cases about area that is reserved for fw region.
> 
> And ? From what I can see in the code, it will still not work properly
> unless all your special cases end up fitting right with the bug you
> effectively have..

not sure.

noticed there some overlapped, and with this patch, those overlapped area disappeared

> 
>> and even there is overlapped area, it the code still can go through when lmb_to_bootmem or create range list for slab.
>> because they are using range array subtract.
> 
> Well, either we just have overlapped areas or we don't ... we shouldn't
> have some kind of overlap_ok() thing that does the right thing ..
> sometimes, but maybe not, but we don't care anyways, which is what you
> seem to be saying.
yes.
> 
>>> Besides, lmb_reserve_area_overlap_ok() sucks as a name :-)
>>
>> any suggestion for better name?
> 
> Well, what you actually implemented is 
> 
> lmb_reserve_area_overlap_maybe_ok_not_too_sure_though()
> 
> What we should decide is once for all, is it ok to have lmb_reserve() be
> called for overlapping ranges. I think the answer is yes and in fact, we
> don't take special care in powerpc either there so overlap could happen
> in theory.
> 
> Now, do we want to avoid actually creating overlapping regions in the
> array ? I think we should look into it, but then we should fix
> lmb_reserve() to do the right thing here and coalesce all the overlaps.

not sure if is needed. lmb_free/lmb_reserve seems work.

YH
