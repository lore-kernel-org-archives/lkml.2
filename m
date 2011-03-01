Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab1CATox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:44:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab1CATow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:44:52 -0500
Message-ID: <4D6D4C9D.60403@zytor.com>
Date: Tue, 01 Mar 2011 11:44:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org> <4D6BE614.3010007@zytor.com> <20110301082915.GC26074@htj.dyndns.org>
In-Reply-To: <20110301082915.GC26074@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 12:29 AM, Tejun Heo wrote:
> Hey,
> 
> (sorry about the earlier empty reply, fat finger on my phone)
> 
> On Mon, Feb 28, 2011 at 10:14:44AM -0800, H. Peter Anvin wrote:
>>> 1. The only rationale given in the commit description is that a
>>>    RED-PEN is killed, which was the following.
>>>
>>> 	/*
>>> 	 * RED-PEN putting page tables only on node 0 could
>>> 	 * cause a hotspot and fill up ZONE_DMA. The page tables
>>> 	 * need roughly 0.5KB per GB.
>>> 	 */
>>>
>>>    This already wasn't true with top-down memblock allocation.
>>>
>>>    The 0.5KB per GiB comment is for 32bit w/ 3 level mapping.  On
>>>    64bit, it's ~4KiB per GiB when using 2MiB mappings and, well, very
>>>    small per GiB if 1GiB mapping is used.  Even with 2MiB mapping,
>>>    1TiB mapping would only be 4MiB.  Under ZONE_DMA, this could be
>>>    problematic but with top-down this can't be a problem in any
>>>    realistic way in foreseeable future.
>>>
>>
>> It's true on 64 bits too when PAE is not available (e.g. with Xen.)
> 
> Hmm... I don't follow.  Can you elaborate?  If PAE is not available
> for whatever reason, the physical memory is limited to 4GiB but I
> don't follow what that has to do with the above.
> 

Sorry, PSE, not PAE.

	-hpa
