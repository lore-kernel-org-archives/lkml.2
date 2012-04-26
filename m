Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2DZB6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 21:58:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44899 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2DZB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 21:58:33 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-ca-4f98abbe7d88
Message-ID: <4F98ABDF.1000702@kernel.org>
Date: Thu, 26 Apr 2012 10:58:55 +0900
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
Subject: Re: [PATCH 5/6] zsmalloc: remove unnecessary type casting
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-6-git-send-email-minchan@kernel.org> <4F97FD9D.9090105@vflare.org>
In-Reply-To: <4F97FD9D.9090105@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:35 PM, Nitin Gupta wrote:

> On 04/25/2012 02:23 AM, Minchan Kim wrote:
> 
>> Let's remove unnecessary type casting of (void *).
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zsmalloc/zsmalloc-main.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index b7d31cc..ff089f8 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -644,8 +644,7 @@ void zs_free(struct zs_pool *pool, void *obj)
>>  	spin_lock(&class->lock);
>>  
>>  	/* Insert this object in containing zspage's freelist */
>> -	link = (struct link_free *)((unsigned char *)kmap_atomic(f_page)
>> -							+ f_offset);
>> +	link = (struct link_free *)(kmap_atomic(f_page)	+ f_offset);
>>  	link->next = first_page->freelist;
>>  	kunmap_atomic(link);
>>  	first_page->freelist = obj;
> 
> 
> 
> Incrementing a void pointer looks weired and should not be allowed by C
> compilers though gcc and clang seem to allow this without any warnings.
> (fortunately C++ forbids incrementing void pointers)


It's a gcc extension and we have been already used lots of place so I think it's no problem
although it's non-standard.
If we compile kernel with -Wpointer-arith, we would find a ton of warning in here and there.

> 
> So, we should keep this cast to unsigned char pointer to avoid relying
> on a non-standard, compiler specific behavior.



Okay. It's a just trivial and I have no justification to do it at the cost of breaking standard.

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
