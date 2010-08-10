Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0HJQNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:13:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29327 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0HJQM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:12:59 -0400
Message-ID: <4C617A1C.9000602@oracle.com>
Date: Tue, 10 Aug 2010 09:11:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (block git tree)
References: <20100806132758.6001d416.sfr@canb.auug.org.au>	<20100806120456.5eca82b7.randy.dunlap@oracle.com>	<4C5C5D18.6050905@oracle.com>	<20100810083737.c761fc8f.randy.dunlap@oracle.com>	<4C617596.505@kernel.dk>	<4C617644.6040105@oracle.com>	<4C6176B2.1050604@kernel.dk> <20100810085946.a8b545e9.randy.dunlap@oracle.com> <4C617956.70003@kernel.dk>
In-Reply-To: <4C617956.70003@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/10 09:07, Jens Axboe wrote:
> On 08/10/2010 11:59 AM, Randy Dunlap wrote:
>> On Tue, 10 Aug 2010 11:56:34 -0400 Jens Axboe wrote:
>>
>>> On 08/10/2010 11:54 AM, Randy Dunlap wrote:
>>>> On 08/10/10 08:51, Jens Axboe wrote:
>>>>> On 08/10/2010 11:37 AM, Randy Dunlap wrote:
>>>>>> On Fri, 06 Aug 2010 12:06:00 -0700 Randy Dunlap wrote:
>>>>>>
>>>>>>> On 08/06/10 12:04, Randy Dunlap wrote:
>>>>>>>> On Fri, 6 Aug 2010 13:27:58 +1000 Stephen Rothwell wrote:
>>>>>>>>
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> As the merge window is open, please do not add 2.6.37 material to your
>>>>>>>>> linux-next included trees until after 2.6.36-rc1.
>>>>>>>>>
>>>>>>>>> Changes since 20100805:
>>>>>>>>>
>>>>>>>>> The block tree lost its build failure and a conflict.
>>>>>>>>
>>>>>>>>
>>>>>>>> Lots of source files now need <linux/blk_types.h>:
>>>>>>>>
>>>>>>>> mm/filemap.c:2164: error: 'REQ_WRITE' undeclared
>>>>>>>> fs/read_write.c:362: error: 'REQ_WRITE' undeclared
>>>>>>>> fs/splice.c:1108: error: 'REQ_WRITE' undeclared
>>>>>>>> fs/aio.c:1496: error: 'REQ_WRITE' undeclared
>>>>>>>> drivers/memstick/core/memstick.c:272: error: 'REQ_WRITE' undeclared
>>>>>>>> drivers/memstick/host/tifm_ms.c:218: error: 'REQ_WRITE' undeclared
>>>>>>>> drivers/memstick/host/jmb38x_ms.c:333: error: 'REQ_WRITE' undeclared
>>>>>>>> drivers/staging/spectra/ffsport.c:277: error: 'REQ_TYPE_LINUX_BLOCK' undeclared
>>>>>>>> fs/compat.c:1274: error: 'REQ_WRITE' undeclared
>>>>>>>
>>>>>>>
>>>>>>> Sorry, I see that this has already been fixed.
>>>>>>
>>>>>> s/fixed/addressed/  but not yet merged into linux-next.
>>>>>> Can we get that fixed, please?
>>>>>
>>>>> Which patch are you referencing?
>>>>
>>>> Hi Jens,
>>>>
>>>> Maybe I misread last week's email about linux/blk_types.h.
>>>> (It was about being exported, not about being #included.)
>>>>
>>>> There are still lots of these files that have the errors listed above.
>>>> Has there been a patch for those?
>>>
>>> What's the .config?
>>
>> I have a bunch of them that fail.  Here are 2 of them,
>> one with CONFIG_BLOCK=y and one with CONFIG_BLOCK=n.
>>
>> I can give you more if you want them.
> 
> Looks like the types are badly hidden behind CONFIG_BLOCK.
> So this should fix the CONFIG_BLOCK=n part at least. What
> was the compile error with CONFIG_BLOCK=y?

Ugh, it is a staging driver with lots of other problems.
(spectra)  I wouldn't worry about it for now.

I'll test this patch.  Thanks.

> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 1185237..5369177 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -108,6 +108,8 @@ struct bio {
>  #define BIO_POOL_MASK		(1UL << BIO_POOL_OFFSET)
>  #define BIO_POOL_IDX(bio)	((bio)->bi_flags >> BIO_POOL_OFFSET)
>  
> +#endif /* CONFIG_BLOCK */
> +
>  /*
>   * Request flags.  For use in the cmd_flags field of struct request, and in
>   * bi_rw of struct bio.  Note that some flags are only valid in either one.
> @@ -189,5 +191,4 @@ enum rq_flag_bits {
>  #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
>  #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
>  
> -#endif /* CONFIG_BLOCK */
>  #endif /* __LINUX_BLK_TYPES_H */
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
