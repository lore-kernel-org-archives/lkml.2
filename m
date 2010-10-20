Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0JTCka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:40:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55765 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0JTCk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:40:29 -0400
Message-ID: <4CBE567B.5030003@zytor.com>
Date: Tue, 19 Oct 2010 19:39:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch]x86: spread tlb flush vector between nodes
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>	 <20101013081629.GA1621@basil.fritz.box>	 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>	 <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>	 <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>	 <20101019084423.GB27723@elte.hu>	 <1287478532.9456.0.camel@sli10-conroe.sh.intel.com>	 <20101019103759.GC32212@elte.hu> <1287494931.1699.12.camel@shli-laptop>	 <20101019133426.GB11654@basil.fritz.box> <1287537221.15980.3.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1287537221.15980.3.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 06:13 PM, Shaohua Li wrote:
> On Tue, 2010-10-19 at 21:34 +0800, Andi Kleen wrote:
>>>  
>>> +static int tlb_vector_offset[NR_CPUS] __read_mostly;
>>
>> Never use NR_CPUS. Always use per cpu data.
>>
>> Otherwise you waste a lot of space on a CONFIG_MAX_SMP
>> kernel running on a smaller box.
> ha, I want it to be __read_mostly to avoid cache pollution, apparently
> we have no per cpu API to do this. Maybe I need add one.
> 

Quite possible, however, definitely percpu over a static array.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

