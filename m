Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab2EQIFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:05:45 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49218 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281Ab2EQIFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:05:33 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-a6-4fb4b14be722
Message-ID: <4FB4B177.9020804@kernel.org>
Date: Thu, 17 May 2012 17:06:15 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] remove dependency with x86
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-2-git-send-email-minchan@kernel.org> <4FB3DFDB.80605@linux.vnet.ibm.com>
In-Reply-To: <4FB3DFDB.80605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 02:11 AM, Seth Jennings wrote:

> On 05/15/2012 09:05 PM, Minchan Kim wrote:
> 
>> Exactly saying, [zram|zcache] should has a dependency with
>> zsmalloc, not x86. So replace x86 dependeny with ZSMALLOC.
>>
>> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zcache/Kconfig |    3 +--
>>  drivers/staging/zram/Kconfig   |    3 +--
>>  2 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
>> index 7048e01..ceb7f28 100644
>> --- a/drivers/staging/zcache/Kconfig
>> +++ b/drivers/staging/zcache/Kconfig
>> @@ -2,8 +2,7 @@ config ZCACHE
>>  	bool "Dynamic compression of swap pages and clean pagecache pages"
>>  	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>>  	# functions
>> -	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
>> -	select ZSMALLOC
>> +	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && ZSMALLOC
> 
> 
> Sorry Minchan, I should have said this the first time around.  I ran
> into this issue before with CRYTPO vs CRYPTO=y.  ZCACHE is a bool where
> ZSMALLOC is a tristate.  It is not sufficient for ZSMALLOC to be set; it
> _must_ be builtin, otherwise you get linker errors.

>

> The dependency should be ZSMALLOC=y.


Sigh. I should have been more careful.
Thanks. I will fix it in next spin.

> 
> Thanks,
> Seth
> 



-- 
Kind regards,
Minchan Kim
