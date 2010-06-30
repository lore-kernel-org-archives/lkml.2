Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0F3WMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:12:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40404 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab0F3WMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Qwj9XRK30GDOqqpW4IAMptX5fDPGFRnanpmn1k9WvUwzLMUG00G3ZvelRxwqNCLAoM
         i0V1S3rAB1ZCFrLWCI56H6G6V2VB4cam8gVO3mQYhQs+dktgHYIllXpSu1gGj8XIrMC0
         nm7uZUb5MwMo6RI3uoDIMO5L+SEeonYg0GKh8=
Message-ID: <4C2BC172.3060201@gmail.com>
Date: Wed, 30 Jun 2010 15:13:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz> <4C2BB52A.7070404@gmail.com> <201006302336.46263.arnd@arndb.de>
In-Reply-To: <201006302336.46263.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:36 PM, Arnd Bergmann wrote:
> On Wednesday 30 June 2010 23:20:42 Justin P. Mattock wrote:
>>
>>> Hehe, ugly. How about making it a single string? GCC preprocessor
>>> documentation suggests the same anyway ...
>>>
>>>        Neither `#error' nor `#warning' macro-expands its argument.
>>>        Internal whitespace sequences are each replaced with a single space.
>>>        The line must consist of complete tokens.  It is wisest to make the
>>>        argument of these directives be a single string constant; this avoids
>>>        problems with apostrophes and the like.
>>>
>
> What this is telling you is to put the text into a string constant, which
> means you add quotation marks at the beginning and end of the line, like
>
> #warning "see http://example.com/"
>

just realized that whole comment. was thrown off by the ` '  things.

>>    From 45f24db45faa06aad01cfc62ff4b475380e5cb11 Mon Sep 17 00:00:00 2001
>> From: Justin P. Mattock<justinmattock@gmail.com>
>> Date: Wed, 30 Jun 2010 14:06:18 -0700
>> Subject: [PATCH]kernel.h Fix #warning message according to the GCC
>> preprocessor docs.
>
> BTW, your mail client adds incorrect word wrapping.
>

I'm copy/pasting from another machine(vnc) somehow thunderbird is 
churning this up when doing so.

>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);
>>
>>    #ifndef __EXPORTED_HEADERS__
>>    #ifndef __KERNEL__
>> -#warning Attempt to use kernel headers from user space, see
>> http://kernelnewbies.org/KernelHeaders
>> +#warning Attempt to use kernel headers from user space!
>>    #endif /* __KERNEL__ */
>>    #endif /* __EXPORTED_HEADERS__ */
>
> Here, too.
>
> Also, since you're already touching the warning message, it would be
> nice to move it from kernel.h to types.h, which is much more commonly
> used. When I introduced the message, I made the mistake to think
> that kernel.h was universally used by the majority of all headers,
> which turned out to be wrong. linux/types.h (or possibly linux/stddef.h)
> seems to be the most commonly used one, so that would be a more
> adequate place.
>
> 	Arnd
>

o.k. just sent a patch, but please have a look, Im not sure if it's 
correct.(if theres a test case I can use let me know, seems my printk 
program is not working with this change).

Justin P. Mattock
