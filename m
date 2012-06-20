Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2FTCzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:55:49 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34095 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2FTCzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:55:48 -0400
Message-ID: <4FE13BAD.4030406@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 10:55:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 03/10] zcache: fix a compile warning
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE03961.5050001@linux.vnet.ibm.com> <4FE08D1A.5060400@linux.vnet.ibm.com>
In-Reply-To: <4FE08D1A.5060400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12062002-2674-0000-0000-000004F4F296
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 10:30 PM, Seth Jennings wrote:

> On 06/19/2012 03:33 AM, Xiao Guangrong wrote:
> 
>> fix:
>>
>> drivers/staging/zcache/zcache-main.c: In function ‘zcache_comp_op’:
>> drivers/staging/zcache/zcache-main.c:112:2: warning: ‘ret’ may be used uninitial
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/zcache/zcache-main.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
>> index 32fe0ba..74a3ac8 100644
>> --- a/drivers/staging/zcache/zcache-main.c
>> +++ b/drivers/staging/zcache/zcache-main.c
>> @@ -93,7 +93,7 @@ static inline int zcache_comp_op(enum comp_op op,
>>  				u8 *dst, unsigned int *dlen)
>>  {
>>  	struct crypto_comp *tfm;
>> -	int ret;
>> +	int ret = -1;
>>
>>  	BUG_ON(!zcache_comp_pcpu_tfms);
>>  	tfm = *per_cpu_ptr(zcache_comp_pcpu_tfms, get_cpu());
> 
> 
> What about adding a default case in the switch like this?
> 
> default:
> 	ret = -EINVAL;
> 
> That way we don't assign ret twice.


Okay, will do it in the next version. Thanks for your review, Seth!

