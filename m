Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0GANeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:34:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0GANeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZmCUb4V1R+yntk1V2TJdbmG9BUWoX/BA9cZYBEB2w0Jn9rZJQw5BdtzgG8DO8EbZyM
         H6Cn6LbQZ5QoB4kuFviPiYGwcc24aAJ70q1RzT7BAiRxvZvkE4ELCgO7x0TYJ+/GFwlI
         4+yeRAYhJ8sCr6Fc2Bi4GDRnHQ9TWrRfYzL6I=
Message-ID: <4C2C9962.3080307@gmail.com>
Date: Thu, 01 Jul 2010 06:34:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers
 for userspace to types.h
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com> <201007010958.46720.arnd@arndb.de>
In-Reply-To: <201007010958.46720.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 12:58 AM, Arnd Bergmann wrote:
> On Thursday 01 July 2010 00:09:45 Justin P. Mattock wrote:
>> Hopefully correct, as request move the function that checks
>> if userspace is using kernel headers, from kernel.h to types.h.
>> (Please check.)
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Trivial change: The 'Signed-off-by'-line should start at the beginning
> of the line, no space in front of it, to make all tools parse
> it correctly.
>
o.k.

> Also, the text above should really be the changelog in the way
> that you want it to appear in the git history. The explanatory
> text about what has changed can go below the '---' line, together
> with the diffstat information. Git only uses text above the line
> as a changeset comment.

cool thanks for the tid bit of info on how git reads these patches
(also later down the line, I'll have to figure out how to have 
thunderbird copy/past patches properly so that life can be easier). .

>
>> --- a/include/linux/types.h
>> +++ b/include/linux/types.h
>> @@ -179,6 +179,12 @@ typedef __u32 __bitwise __wsum;
>>   typedef unsigned __bitwise__ gfp_t;
>>   typedef unsigned __bitwise__ fmode_t;
>>
>> +#ifndef __EXPORTED_HEADERS__
>> +#ifndef __KERNEL__
>> +#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"

so this is legit with the length of the statement? or should this be 
broken down into a small quick line directing to a file with the address 
or something

>> +#endif /* __KERNEL__ */
>> +#endif /* __EXPORTED_HEADERS__ */
>> +
>>   #ifdef CONFIG_PHYS_ADDR_T_64BIT
>>   typedef u64 phys_addr_t;
>
> Good: No more linewrap, correct use of quotation marks.
> Bad: This is now inside of #ifdef __KERNEL__, so it can never be caught by
> the compiler. Even if it looks like a trivial patch, it's a good idea
> to test it.
>

thats probably why this wasnt firing off, before I had sent it out I 
though twice about it, but then figured better to get it out there, then 
go from there.

> I'd suggest putting the #ifndef __EXPORTED_HEADERS__ into a new #else
> path of the last #ifdef __KERNEL__ of this file.
>

alright.. I look into this and resend

> Anyway, thanks for the persistence, I know it's frustrating when a one-line
> change goes through half a dozen revisions.
>
> 	Arnd
>


it does seem frustrating, but honestly I am actually excited to do such 
a thing, main issue is energy i.g. doing this when/after spending hours 
already is a bit intense...

Justin P. Mattock
