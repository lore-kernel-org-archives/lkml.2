Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0L1WKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 17:10:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35856 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab0L1WKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 17:10:11 -0500
Message-ID: <4D1A6021.2010905@zytor.com>
Date: Tue, 28 Dec 2010 14:09:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0/3] memblock related top down
References: <4D0C072D.1040201@kernel.org>	<4D1A46D2.1000702@zytor.com> <AANLkTik7Zbc4KW0rS1h=qsLwm-NCxHNjLUZnLi1t0sr5@mail.gmail.com>
In-Reply-To: <AANLkTik7Zbc4KW0rS1h=qsLwm-NCxHNjLUZnLi1t0sr5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2010 01:36 PM, Yinghai Lu wrote:
> On Tue, Dec 28, 2010 at 12:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/17/2010 04:58 PM, Yinghai Lu wrote:
>>> Please check
>>>
>>> Those three patches to make memblock allocation more top to down.
>>>
>>
>> Please explain what you mean with "more top to down".  Not what the code
>> does, but what is the goal of the patchset.
> 
> for example first node with 16g ram, it is into two parts: [0, 2g),
> and [4g, 18g).
> 
> alloc_bootmem will get allocation from [0, 2g) always until we have
> can not find more.
> 
> with third patch, it will try to get from [4g, 18g) at first.
> 
> second patch is need to applied before third patch, because old way
> happenly get under 4g for generic bootmem under 4g
> 
> First one is trying not to put page table for [0, 4g) under 512M.
> 

The goal of this is to free up low memory for DMA and kdump, I presume?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

