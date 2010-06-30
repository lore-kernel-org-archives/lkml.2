Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0F3NeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:34:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34433 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0F3NeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L3AAPL7ro5cz/7Nnrqm1vFfWBjBtve68H+UzBAUNH0l80n37t4LQk/UPdOld1Kv01M
         3kiCsySZFl5axGk8JyvwuJ78AqEcsmPQjv5IP1tW9TOC/Skbf23JL20tww2gNg3tqZmm
         9Cgwbj2nKThhBvXsIMlHaH8yquWaDGVk3xS1I=
Message-ID: <4C2B468F.3020600@gmail.com>
Date: Wed, 30 Jun 2010 06:28:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:48 AM, Jiri Kosina wrote:
> On Tue, 29 Jun 2010, Justin P. Mattock wrote:
>
>> Playing around with a printk program I noticed that the #warning
>> message is incomplete(when using kernel headers for userspace):
>>
>>   gcc printk.c -o printk
>> In file included from printk.c:3:
>> include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel headers from user space, see http:
>>
>> My guess for the web address not being displayed is "//" is treated as a comment.
>> So after changing "http://" to "www." I get the web address.(using firefox with this
>> address takes me right to the location). The warning looks like this:
>>
>> In file included from printk.c:3:
>> warning: #warning Attempt to use kernel headers from user space, see www.kernelnewbies.org/KernelHeaders
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   include/linux/kernel.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 8317ec4..768196a 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);
>>
>>   #ifndef __EXPORTED_HEADERS__
>>   #ifndef __KERNEL__
>> -#warning Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders
>> +#warning Attempt to use kernel headers from user space, see www.kernelnewbies.org/KernelHeaders
>>   #endif /* __KERNEL__ */
>>   #endif /* __EXPORTED_HEADERS__ */
>
> Hehe, ugly. How about making it a single string? GCC preprocessor
> documentation suggests the same anyway ...
>
> 	Neither `#error' nor `#warning' macro-expands its argument.
> 	Internal whitespace sequences are each replaced with a single space.
> 	The line must consist of complete tokens.  It is wisest to make the
> 	argument of these directives be a single string constant; this avoids
> 	problems with apostrophes and the like.
>


before the www. idea, I was thinking maybe sending the address to a file 
somewhere in documentation
something in this area:

#warning Using kernel headers from user space, please see Documentation/*

but I still need to re-read what the above says, seems a bit technical..

Justin P. Mattock
