Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab0C3EW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 00:22:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0C3EWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 00:22:55 -0400
Message-ID: <4BB17C36.3030406@kernel.org>
Date: Mon, 29 Mar 2010 21:21:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>	 <1269901252.2286.11.camel@concordia>  <4BB12BBA.4060108@kernel.org>	 <1269905664.7101.43.camel@pasglop>  <4BB13D61.3040902@kernel.org> <1269922383.15854.68.camel@concordia>
In-Reply-To: <1269922383.15854.68.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 09:13 PM, Michael Ellerman wrote:
> On Mon, 2010-03-29 at 16:53 -0700, Yinghai Lu wrote:
>> On 03/29/2010 04:34 PM, Benjamin Herrenschmidt wrote:
>>> On Mon, 2010-03-29 at 15:37 -0700, Yinghai Lu wrote:
>>>>> We just need a lmb.alloc_limit and a lmb_set_alloc_limit() which arch
>>>>> code calls when it knows what the alloc limit is (and can call multiple
>>>>> times during boot). Or maybe it should be called "default_alloc_limit",
>>>>> but that's getting a bit long winded.
>>>>
>>>> ok, I will get_max_mapped() for now, an will change to new field...later
>>>
>>> No. Do it now. get_max_mapped() sucks as an identifier.
>>>
>>
>> ok, can i reuse rmo_size, or introduce one new member in struct lmb.
>>
>> default_limit?
> 
> alloc_limit or default_alloc_limit
> 
looks that is not accurate.

if someone want to find some area, but not going to access that range, then we should let them alloc it.

how about access_limit?

Thanks

Yinghai Lu
