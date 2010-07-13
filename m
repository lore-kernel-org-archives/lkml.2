Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab0GMUnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:43:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40192 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0GMUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:43:49 -0400
Message-ID: <4C3CCF52.5040401@kernel.org>
Date: Tue, 13 Jul 2010 13:40:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 45/50] x86, memblock: Use memblock_debug to control debug
 message print out
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org> <1279005044-24777-46-git-send-email-yinghai@kernel.org> <201007131437.55808.bjorn.helgaas@hp.com>
In-Reply-To: <201007131437.55808.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3CCFE8.0080,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 01:37 PM, Bjorn Helgaas wrote:
> On Tuesday, July 13, 2010 01:10:39 am Yinghai Lu wrote:
>> -		pr_cont(" ==> [%010llx-%010llx]\n", final_start, final_end - 1);
>> +		memblock_dbg(" ==> [%#010llx-%#010llx]\n", final_start, final_end - 1);
>>  		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
>>  	}
>>  
>> @@ -286,9 +286,11 @@ void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
>>  	if (start == end)
>>  		return;
>>  
>> -	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx]\n", start, end))
>> +	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx)\n", start, end))
> 
> Can you print these ranges the same way as the others?  I think
> "invalid range" might be closer to what you mean than "wrong range." 

like to use end instead of end - 1.

> 
> I'm a little dubious about these "(start == end)" and "(start > end)"
> checks anyway.  Who are the callers of these functions?  If "start"
> and "end" are coming from an external source, e.g., some firmware
> interface like an e820 table, the message doesn't give enough of a
> clue about where the problem is.
> 
> If "start" and "end" are internal things, I'd argue that the checks
> are just covering up Linux bugs, and it'd be better to fix those
> bugs and remove the checks.

so we add WARN_ here, could warn the possible wrong usage.

YH
