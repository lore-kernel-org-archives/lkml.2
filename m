Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2GREre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:47:34 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44734 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2GREr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:47:29 -0400
Message-ID: <50063FAA.9060302@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 12:46:34 +0800
From: don <haodong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify the kobject_init function.
References: <1342073375-27181-1-git-send-email-haodong@linux.vnet.ibm.com> <20120717164024.GA7225@kroah.com>
In-Reply-To: <20120717164024.GA7225@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12071718-5490-0000-0000-000001CBFA08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月18日 00:40, Greg KH 写道:
> On Thu, Jul 12, 2012 at 02:09:35PM +0800, Dong Hao wrote:
>> The printk() function at the end of function kobject_init() already had '\n',
>> so remove it.
>>
>> While the kobject has been initialized, assign error string and
>> jump to error case directly.
>>
>> Signed-off-by: Dong Hao<haodong@linux.vnet.ibm.com>
>> ---
>>   lib/kobject.c |    9 ++++-----
>>   1 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index 05de4dc..7b8a09c 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -278,14 +278,13 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
>>   		goto error;
>>   	}
>>   	if (!ktype) {
>> -		err_str = "must have a ktype to be initialized properly!\n";
>> +		err_str = "must have a ktype to be initialized properly!";
>>   		goto error;
>>   	}
>>   	if (kobj->state_initialized) {
>> -		/* do not error out as sometimes we can recover */
>> -		printk(KERN_ERR "kobject (%p): tried to init an initialized "
>> -		       "object, something is seriously wrong.\n", kobj);
>> -		dump_stack();
>> +		err_str = "tried to init an initialized "
>> +			"object, something is seriously wrong.";
>> +		goto error;
> You were already told why this patch is incorrect, why are you resending
> it two more times?  That's a bit annoying and rude, don't you think?
>
> Sorry, I can't take this, please read the code you are modifying.
>
> greg k-h
>
Greg, sorry for the noise caused by wrong configuration of email client.
Let me change it according to the given suggestion and come up with a
new version against the patch if you agree.


