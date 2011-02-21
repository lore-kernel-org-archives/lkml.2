Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab1BUU26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:28:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62054 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1BUU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:28:57 -0500
Message-ID: <4D62CAE4.4040207@kernel.org>
Date: Mon, 21 Feb 2011 12:28:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for early_node_mem()
References: <4D5EC05A.60103@kernel.org> <4D5EC184.6000505@kernel.org> <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com> <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com> <20110221094318.GG31267@htj.dyndns.org> <20110221104443.GJ31267@htj.dyndns.org>
In-Reply-To: <20110221104443.GJ31267@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4D62CAF4.0113,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 02:44 AM, Tejun Heo wrote:
> On Mon, Feb 21, 2011 at 10:43:18AM +0100, Tejun Heo wrote:
>> Hello,
>>
>> On Sat, Feb 19, 2011 at 08:17:11PM -0800, Yinghai Lu wrote:
>>>> The old code guarantees that the range is from a single zone, and even
>>>> though memblock may be top -> down, it seems like there would be
>>>> configurations where this would still be an issue (perhaps simulating it
>>>> with numa=fake for testing?) if it crosses the boundary.
>>>
>>> memblock_x86_find_in_range_node() will go over with early_node_map[].
>>> so it will always can get right on node allocation.
>>
>> I think always doing top-down allocation should be enough as long as
>> there's no highmem, which we don't have on 64bit.  That said, the
>> patch description should note the behavior difference.  Yinghai, care
>> to add a bit more detail to the patch description?
> 
> Hmmm... thinking more about it, there actually is a difference.
> Depending on configuration, the new code allows node_data[] to be
> allocated below DMA boundary.  I think we need to keep the first if().
> Areas crossing the boundaries is okay, in fact, the original code
> already allowed that when the NUMA affine allocation failed; however,
> node_data[] was never allowed below the DMA boundary and I think it
> shouldn't be.

No. when those code were added before. it was bottom-up allocation from e820.

Now with new memblock allocation. it will always try to do top down. 

will have no chance to get under DMA normally.

except your first node only has < 16M.

Thanks

Yinghai Lu
