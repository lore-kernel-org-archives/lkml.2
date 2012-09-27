Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2I0KsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:48:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:38967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2I0KsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:48:18 -0400
Message-ID: <50642ECB.20707@kernel.dk>
Date: Thu, 27 Sep 2012 12:47:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scatterlist: add sg_nents
References: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com> <1348652941-31899-2-git-send-email-maximlevitsky@gmail.com> <20120926163851.GP16296@google.com>
In-Reply-To: <20120926163851.GP16296@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 06:38 PM, Tejun Heo wrote:
> (cc'ing Jens)
> 
> On Wed, Sep 26, 2012 at 11:49:00AM +0200, Maxim Levitsky wrote:
>> Useful helper to know the number of entries in scatterlist.
>>
>> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>> ---
>>  include/linux/scatterlist.h |    1 +
>>  lib/scatterlist.c           |   22 ++++++++++++++++++++++
>>  2 files changed, 23 insertions(+)
>>
>> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>> index 7b600da..4bd6c06 100644
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -201,6 +201,7 @@ static inline void *sg_virt(struct scatterlist *sg)
>>  	return page_address(sg_page(sg)) + sg->offset;
>>  }
>>  
>> +int sg_nents(struct scatterlist *sg);
>>  struct scatterlist *sg_next(struct scatterlist *);
>>  struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
>>  void sg_init_table(struct scatterlist *, unsigned int);
>> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>> index e76d85c..5cd9cdc 100644
>> --- a/lib/scatterlist.c
>> +++ b/lib/scatterlist.c
>> @@ -39,6 +39,28 @@ struct scatterlist *sg_next(struct scatterlist *sg)
>>  EXPORT_SYMBOL(sg_next);
>>  
>>  /**
>> + * sg_nents - return total count of entries in scatterlist
>> + * @sg:		The scatterlist
>> + *
>> + * Description:
>> + * Allows to know how many entries are in sg, taking into acount
>> + * chaining as well
>> + *
>> + **/
>> +int sg_nents(struct scatterlist *sg)
>> +{
>> +	int nents = 0;
>> +	while (sg) {
>> +		nents++;
>> +		sg = sg_next(sg);
>> +	}
>> +
>> +	return nents;
>> +}
>> +EXPORT_SYMBOL(sg_nents);
> 
> How about the following instead?
> 
> 	for (nents = 0; sg; sg = sg_next(sg))
> 		nents++;
> 	return nents;
> 
> Other than that,
> 
>  Acked-by: Tejun Heo <tj@kernel.org>

Agree, that'd be cleaner. I've just applied it as-is. Maxim, feel free
to send an update to it. I pulled the driver bit into the
for-3.7/drivers branch as well.

-- 
Jens Axboe

