Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2AaDdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:33:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab2AaDdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:33:46 -0500
Message-ID: <4F2761B2.7080207@redhat.com>
Date: Tue, 31 Jan 2012 11:36:18 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add kernel parameter to disable module load
References: <20120128033450.GA2138@darkstar> <87vcnvbab1.fsf@rustcorp.com.au> <4F2755A2.5040108@redhat.com> <871uqglgpf.fsf@rustcorp.com.au>
In-Reply-To: <871uqglgpf.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 10:59 AM, Rusty Russell wrote:

> On Tue, 31 Jan 2012 10:44:50 +0800, Dave Young <dyoung@redhat.com> wrote:
>> On 01/29/2012 08:51 AM, Rusty Russell wrote:
>>
>>> On Sat, 28 Jan 2012 11:34:50 +0800, Dave Young <dyoung@redhat.com> wrote:
>>>> Sometimes we need to test a kernel of same version with code or config
>>>> option changes.
>>>>
>>>> We already have sysctl to disable module load, but add a kernel
>>>> parameter will be more convenient.
>>>
>>>
>>>> +static int __init module_load_disable(char *str)
>>>> +{
>>>> +	modules_disabled = 1;
>>>> +	return 1;
>>>> +}
>>>> +__setup("nomodule", module_load_disable);
>>>
>>> You misspelled core_param here :)
>>>
>>
>>
>> Hello Rusty, If use core_param I'd better to change modules_disabled
>> from int to bool or we must pass nomodule=1 instead of simply pass
>> nomodule. But I think I can firstly post the core_param patch with
>> current int type, then work on the transition patch for the variable
>> type changes, what do you think?
> 
> You could code your set function, but "bint" is what you want.  Cleaning
> it up to be a bool is a good idea too.


Thanks. I will try bint. Will consider to make it bool later because
sysctl also need some changes.

> 
>> Another do you think we need to expose this to sysfs via core_param?
>> According to the sysctl code looks like we should not add sysfs
>> interface to allow transition from "1" to "0"
> 
> If you want it writable, you definitely want to code your own set
> function so it's one way.  But perm 0 or 0444 make sense, too.


I like 'perm 0' :)

> 
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks
Dave
