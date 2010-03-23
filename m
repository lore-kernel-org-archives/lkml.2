Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0CWRT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:19:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:55612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab0CWRT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:19:26 -0400
Message-ID: <4BA8F7BD.20401@kernel.org>
Date: Tue, 23 Mar 2010 10:17:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region
 struct
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org> <1269333587-1866-5-git-send-email-yinghai@kernel.org> <4BA899C2.8020208@kernel.org> <20100323104241.GA1189@elte.hu> <20100323131839.GA31552@linux-sh.org>
In-Reply-To: <20100323131839.GA31552@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 06:18 AM, Paul Mundt wrote:
> On Tue, Mar 23, 2010 at 11:42:41AM +0100, Ingo Molnar wrote:
>>
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>>  void __init lmb_init(void)
>>>  {
>>> +	lmb.memory.region   = lmb_memory_region;
>>> +	lmb.memory.region_array_size   = ARRAY_SIZE(lmb_memory_region);
>>> +	lmb.reserved.region = lmb_reserved_region;
>>> +	lmb.reserved.region_array_size = ARRAY_SIZE(lmb_reserved_region);
>>> +
>>
>> That's rather unreadable and has random whitespace noise.
>>
>> Should be something like:
>>
>> 	lmb.memory.region		= lmb_memory_region;
>> 	lmb.memory.region_array_size	= ARRAY_SIZE(lmb_memory_region);
>> 	lmb.reserved.region		= lmb_reserved_region;
>> 	lmb.reserved.region_array_size	= ARRAY_SIZE(lmb_reserved_region);
>>
>> also, i'd suggest to shorten region_array_size to region_size (we know it's an 
>> array), so it would become:
>>
>> 	lmb.memory.region	 = lmb_memory_region;
>> 	lmb.memory.region_size	 = ARRAY_SIZE(lmb_memory_region);
>>
> I don't mean to be pedantic, but the LMB code already has a lot of
> region.size references so region_size looks a bit awkward. All of the
> accessors in linux/lmb.h use region_nr as the array index, so perhaps
> nr_regions would be less ambiguous.

@@ -26,7 +26,8 @@ struct lmb_property {
 struct lmb_region {
 	unsigned long cnt;
 	u64 size;
-	struct lmb_property region[MAX_LMB_REGIONS+1];
+	struct lmb_property *region;
+	unsigned long region_array_size;
 };

cnt is number of slots used.
size is memory size

can we use rgn_sz for region array size?

YH
