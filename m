Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab0FKWDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:03:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53996 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0FKWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qAsFxlZbIo3f/hAbDtWtggSM+AnyTzuncq+1U9X+L7bqlZCrCeGXGSdfj0uy4CV4Ox
         lv7S/dC5IJnqPCnyAyxyUcmBBFE4FJncF2h/u+P5xpCTuVrTHscjr6qOyorHlNOu33vx
         l2bPCkPSOipk2N8c8bi7INRI8BbEf5JOnwuP0=
Message-ID: <4C12B2BD.1020108@gmail.com>
Date: Fri, 11 Jun 2010 15:03:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 2/6]kernel:audit.c Fix warning: variable 'nlh' set but
 not 	used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>	<1276288869-16815-3-git-send-email-justinmattock@gmail.com> <AANLkTildzUcfd6GghHbO53ebPAc4m4BahJrXUr8B7SQF@mail.gmail.com>
In-Reply-To: <AANLkTildzUcfd6GghHbO53ebPAc4m4BahJrXUr8B7SQF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 02:14 PM, Geert Uytterhoeven wrote:
> On Fri, Jun 11, 2010 at 22:41, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> Removing dead code(hopefully), fixes a warning
>
> This is not dead code. NLMSG_NEW() sets up an nlmsg in ab->skb.
> If you remove the code, it's no longer initialized.
>

o.k... this one did confuse me a bit, so at the end
I just sent in this one which does remove the function
but does not fix the warning of nlh not being used

>> when compiling the kernel.
>>
>>   CC      kernel/audit.o
>> kernel/audit.c: In function 'audit_buffer_alloc':
>> kernel/audit.c:1044:19: warning: variable 'nlh' set but not used
>>   CC      kernel/auditfilter.o
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   kernel/audit.c |    6 ++----
>>   1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index c71bd26..783d958 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -1041,8 +1041,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
>>   {
>>         unsigned long flags;
>>         struct audit_buffer *ab = NULL;
>> -       struct nlmsghdr *nlh;
>> -
>> +
>>         spin_lock_irqsave(&audit_freelist_lock, flags);
>>         if (!list_empty(&audit_freelist)) {
>>                 ab = list_entry(audit_freelist.next,
>> @@ -1065,8 +1064,7 @@ static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
>>         if (!ab->skb)
>>                 goto nlmsg_failure;
>>
>> -       nlh = NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
>> -
>> +
>>         return ab;
>>
>>   nlmsg_failure:                  /* Used by NLMSG_NEW */
>
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
>

if you have any ideas/patches then let me know
I can test it out and see.

Justin P. Mattock
