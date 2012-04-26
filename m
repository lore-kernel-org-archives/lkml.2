Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2DZBmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 21:42:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62708 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2DZBmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 21:42:15 -0400
X-AuditID: 9c930179-b7bfaae000006f69-f4-4f98a7f407e4
Message-ID: <4F98A818.1080106@kernel.org>
Date: Thu, 26 Apr 2012 10:42:48 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] zsmalloc: remove unnecessary alignment
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-3-git-send-email-minchan@kernel.org> <4F97F3D6.8000404@vflare.org>
In-Reply-To: <4F97F3D6.8000404@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 09:53 PM, Nitin Gupta wrote:

> On 04/25/2012 02:23 AM, Minchan Kim wrote:
> 
>> It isn't necessary to align pool size with PAGE_SIZE.
>> If I missed something, please let me know it.
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zsmalloc/zsmalloc-main.c |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 504b6c2..b99ad9e 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -489,14 +489,13 @@ fail:
>>  
>>  struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
>>  {
>> -	int i, error, ovhd_size;
>> +	int i, error;
>>  	struct zs_pool *pool;
>>  
>>  	if (!name)
>>  		return NULL;
>>  
>> -	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
>> -	pool = kzalloc(ovhd_size, GFP_KERNEL);
>> +	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
>>  	if (!pool)
>>  		return NULL;
>>  
> 
> 
> pool metadata is rounded-up to avoid potential false-sharing problem
> (though we could just roundup to cache_line_size()).


Do you really have any hurt by false-sharing problem?
If so, we can change it with

kzalloc(ALIGN(sizeof(*pool), cache_line_size()), GFP_KERNEL);

But I am not sure we need this.

> 
> Thanks,
> Nitin
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
