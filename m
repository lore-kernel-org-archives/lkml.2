Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab2DLSEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:04:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51587 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab2DLSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:04:16 -0400
Message-ID: <4F871919.5090003@gmail.com>
Date: Thu, 12 Apr 2012 11:04:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH]NEXT:drivers:staging:ramster Fix typos and remove CONFIG_BROKEN
 in staging:ramster
References: <<1333982937-12929-1-git-send-email-user@Ideapad-Z560>> <8f7aee45-fc5c-43b2-97cc-30c142927dc3@default>
In-Reply-To: <8f7aee45-fc5c-43b2-97cc-30c142927dc3@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 09:50 AM, Dan Magenheimer wrote:
>> From: Justin P. Mattock [mailto:justinmattock@gmail.com]
>> Sent: Monday, April 09, 2012 8:49 AM
>> To: dan.magenheimer@oracle.com
>> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Justin P. Mattock
>> Subject: [PATCH]NEXT:drivers:staging:ramster Fix typos and remove CONFIG_BROKEN in staging:ramster
>>
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>> The below patch fixes some typos that I found while reading. And also removes
>> CONFIG_BROKEN since it is no longer used.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> Hi Justin --
>
> Thanks for your interest and for the patch!
>
> The removal of CONFIG_BROKEN is already in GregKH's staging tree(s)
> and in linux-next, and will hopefully be in -rc3.
>
> The comment typos do need to be fixed but I'm not sure if they should
> go through the staging tree or through trivial, but in either case
> consider them:
>
> Acked-by: Dan Magenheimer<dan.magenheimer@oracle.com>
>
>
>> ---
>>   drivers/staging/ramster/Kconfig       |    6 +-----
>>   drivers/staging/ramster/cluster/tcp.c |    4 ++--
>>   drivers/staging/ramster/xvmalloc.c    |    2 +-
>>   drivers/staging/ramster/zcache-main.c |    2 +-
>>   4 files changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
>> index 8b57b87..2932c65 100644
>> --- a/drivers/staging/ramster/Kconfig
>> +++ b/drivers/staging/ramster/Kconfig
>> @@ -1,10 +1,6 @@
>> -# Dependency on CONFIG_BROKEN is because there is a commit dependency
>> -# on a cleancache naming change to be submitted by Konrad Wilk
>> -# a39c00ded70339603ffe1b0ffdf3ade85bcf009a "Merge branch 'stable/cleancache.v13'
>> -# into linux-next.  Once this commit is present, BROKEN can be removed
>>   config RAMSTER
>>   	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
>> -	depends on (CLEANCACHE || FRONTSWAP)&&  CONFIGFS_FS=y&&  !ZCACHE&&  !XVMALLOC&&  !HIGHMEM&&
>> BROKEN
>> +	depends on (CLEANCACHE || FRONTSWAP)&&  CONFIGFS_FS=y&&  !ZCACHE&&  !XVMALLOC&&  !HIGHMEM
>>   	select LZO_COMPRESS
>>   	select LZO_DECOMPRESS
>>   	default n
>> diff --git a/drivers/staging/ramster/cluster/tcp.c b/drivers/staging/ramster/cluster/tcp.c
>> index 3af1b2c..3490192 100644
>> --- a/drivers/staging/ramster/cluster/tcp.c
>> +++ b/drivers/staging/ramster/cluster/tcp.c
>> @@ -111,7 +111,7 @@ static struct socket *r2net_listen_sock;
>>    * r2net_wq.  teardown detaches the callbacks before destroying the workqueue.
>>    * quorum work is queued as sock containers are shutdown.. stop_listening
>>    * tears down all the node's sock containers, preventing future shutdowns
>> - * and queued quroum work, before canceling delayed quorum work and
>> + * and queued quorum work, before canceling delayed quorum work and
>>    * destroying the work queue.
>>    */
>>   static struct workqueue_struct *r2net_wq;
>> @@ -660,7 +660,7 @@ out:
>>
>>   /*
>>    * we register callbacks so we can queue work on events before calling
>> - * the original callbacks.  our callbacks our careful to test user_data
>> + * the original callbacks.  our callbacks are careful to test user_data
>>    * to discover when they've reaced with r2net_unregister_callbacks().
>>    */
>>   static void r2net_register_callbacks(struct sock *sk,
>> diff --git a/drivers/staging/ramster/xvmalloc.c b/drivers/staging/ramster/xvmalloc.c
>> index 93ba8e9..44ceb0b 100644
>> --- a/drivers/staging/ramster/xvmalloc.c
>> +++ b/drivers/staging/ramster/xvmalloc.c
>> @@ -132,7 +132,7 @@ static u32 find_block(struct xv_pool *pool, u32 size,
>>   	if (!pool->flbitmap)
>>   		return 0;
>>
>> -	/* Get freelist index correspoding to this size */
>> +	/* Get freelist index corresponding to this size */
>>   	slindex = get_index(size);
>>   	slbitmap = pool->slbitmap[slindex / BITS_PER_LONG];
>>   	slbitstart = slindex % BITS_PER_LONG;
>> diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
>> index 36d53ed..de082cc 100644
>> --- a/drivers/staging/ramster/zcache-main.c
>> +++ b/drivers/staging/ramster/zcache-main.c
>> @@ -2095,7 +2095,7 @@ out:
>>   /*
>>    * Called on a remote persistent tmem_get to attempt to preallocate
>>    * local storage for the data contained in the remote persistent page.
>> - * If succesfully preallocated, returns the pampd, marked as remote and
>> + * If successfully preallocated, returns the pampd, marked as remote and
>>    * in_transit.  Else returns NULL.  Note that the appropriate tmem data
>>    * structure must be locked.
>>    */
>> --
>> 1.7.5.4


alright! let me pull -next again to see if its in.. I will resend 
without CONFIG_BROKEN..

Thanks for the info.

Justin P. Mattock
