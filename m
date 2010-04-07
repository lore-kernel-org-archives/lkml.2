Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0DGXkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:40:45 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:47958 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0DGXkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:40:43 -0400
Message-ID: <4BBD171A.3020108@oracle.com>
Date: Wed, 07 Apr 2010 16:36:58 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/33] lmb: Add lmb_reserve_area/lmb_free_area
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>	 <1270001838-15857-7-git-send-email-yinghai@kernel.org> <1270683308.9521.7.camel@concordia>
In-Reply-To: <1270683308.9521.7.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBD17A3.008C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 04:35 PM, Michael Ellerman wrote:
> On Tue, 2010-03-30 at 19:16 -0700, Yinghai Lu wrote:
>> They will check if the region array is big enough.
>>
>> __check_and_double_region_array will try to double the region array if that
>> array spare slots is not big enough.  Old array will be copied to new array.
>>
> 
>> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
>> index 4cf2f3b..598662f 100644
>> --- a/include/linux/lmb.h
>> +++ b/include/linux/lmb.h
>> @@ -83,6 +84,9 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
>>  	       lmb_size_pages(type, region_nr);
>>  }
>>  
>> +void lmb_reserve_area(u64 start, u64 end, char *name);
>> +void lmb_free_area(u64 start, u64 end);
>> +void lmb_add_memory(u64 start, u64 end);
> 
> vs
> 
> extern long lmb_reserve(u64 base, u64 size);
> extern long lmb_free(u64 base, u64 size);   
> extern long lmb_add(u64 base, u64 size);                                    
>                          
> 
> Can you tell which ones handle dynamically expanding the region array?
> 
> You're _still_ adding a new API, which I still think is stupid.

please consider to merge them later.

Don't want to break current lmb users

YH
