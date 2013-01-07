Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3AGBav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:30:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab3AGBas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:30:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,421,1355068800"; 
   d="scan'208";a="6532369"
Message-ID: <50EA2511.3070009@cn.fujitsu.com>
Date: Mon, 07 Jan 2013 09:29:53 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, mingo@kernel.org, yinghai@kernel.org,
        liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: memblock: fix wrong memmove size in memblock_merge_regions()
References: <1357290650-25544-1-git-send-email-linfeng@cn.fujitsu.com> <20130104145635.GA15633@mtj.dyndns.org>
In-Reply-To: <20130104145635.GA15633@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 09:30:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 09:30:17,
	Serialize complete at 2013/01/07 09:30:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/04/2013 10:56 PM, Tejun Heo wrote:
> On Fri, Jan 04, 2013 at 05:10:50PM +0800, Lin Feng wrote:
>> The memmove span covers from (next+1) to the end of the array, and the index
>> of next is (i+1), so the index of (next+1) is (i+2). So the size of remaining
>> array elements is (type->cnt - (i + 2)).
>>
>> PS. It seems that memblock_merge_regions() could be made some improvement:
>> we need't memmove the remaining array elements until we find a none-mergable
>> element, but now we memmove everytime we find a neighboring compatible region.
>> I'm not sure if the trial is worth though.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>> ---
>>  mm/memblock.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 6259055..85ce056 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -314,7 +314,7 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
>>  		}
>>  
>>  		this->size += next->size;
>> -		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
>> +		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
> 
> Heh, that's confusing.  Nice catch.  Can you please also add a comment
> explaning the index so that it's less confusing for the future readers?
Hi Tejun,

Glad to. I will resend it soon.

thanks,
linfeng
> 
> Thanks.
> 
