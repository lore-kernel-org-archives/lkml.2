Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0FSUKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:10:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63834 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0FSUKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CT5wjM+GYS+mGizftA0tzgD1a4sYM4a/9MGUc4KVTGapS/CmHpR75ucbceKOuTyRAT
         Jp9RmoRW0Z7j7RKDA2uFQUxFwTuC9TMv82kNMMdIWz1MmIp+ITjTSIvfx008Qrd1gBfH
         rE/SxMPpsG4IBzF/2yw+O3gzZR+nZEDVdD570=
Message-ID: <4C1D243D.2070302@gmail.com>
Date: Sat, 19 Jun 2010 13:10:37 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 5/6]kernel:module.c variable 'nowarn' set but not used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>	<1276288869-16815-6-git-send-email-justinmattock@gmail.com>	<AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>	<4C1C4FDE.2090101@gmail.com>	<AANLkTin5ovxSSsIM-1R-u7mmoqxp8UnxgtkuVJfZU2ES@mail.gmail.com>	<4C1D160D.5030303@gmail.com> <AANLkTikOP99vtHOmfLZ05TkGFK8ffVNSSDoBvgCaIMCi@mail.gmail.com>
In-Reply-To: <AANLkTikOP99vtHOmfLZ05TkGFK8ffVNSSDoBvgCaIMCi@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 12:45 PM, Geert Uytterhoeven wrote:
> On Sat, Jun 19, 2010 at 21:10, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 06/19/2010 01:08 AM, Geert Uytterhoeven wrote:
>>>
>>> On Sat, Jun 19, 2010 at 07:04, Justin P. Mattock
>>> <justinmattock@gmail.com>    wrote:
>>>>>
>>>>> Also wrong, you removed the creation of the links in sysfs.
>>>>>
>>>>> The assignment to nowarn was there to avoid another compiler warning,
>>>>> as sysfs_create_link() is marked __must_check.
>>>>
>>>> I also went back to this one and made the following changes.. let me know
>>>> if
>>>> it's wrong etc..
>>>>
>>>>   From 4f45beed80627d2bb32fb021bb6d22d88089557b Mon Sep 17 00:00:00 2001
>>>> From: Justin P. Mattock<justinmattock@gmail.com>
>>>> Date: Fri, 18 Jun 2010 22:01:07 -0700
>>>> Subject: [PATCH 5/5] module.c
>>>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>> ---
>>>>   kernel/module.c |    3 +--
>>>>   1 files changed, 1 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel/module.c b/kernel/module.c
>>>> index 8c6b428..48fc5c8 100644
>>>> --- a/kernel/module.c
>>>> +++ b/kernel/module.c
>>>> @@ -1340,11 +1340,10 @@ static void add_usage_links(struct module *mod)
>>>>   {
>>>>   #ifdef CONFIG_MODULE_UNLOAD
>>>>         struct module_use *use;
>>>> -       int nowarn;
>>>>
>>>>         mutex_lock(&module_mutex);
>>>>         list_for_each_entry(use,&mod->target_list, target_list) {
>>>> -               nowarn = sysfs_create_link(use->target->holders_dir,
>>>> +               sysfs_create_link(use->target->holders_dir,
>>>>                                            &mod->mkobj.kobj, mod->name);
>>>>         }
>>>>         mutex_unlock(&module_mutex);
>>>> --
>>>> 1.7.1.rc1.21.gf3bd6
>>>>
>>>> if it looks good, then I can resend it out.
>>>
>>> Have you compile-tested this?
>>> As sysfs_create_link() is marked __must_check, that will cause another
>>> compiler
>>> warning, but only if CONFIG_SYSFS=y.
>>>
>>> Perhaps you can just mark the nowarn variable __unused?
>>
>>
>> o.k. this builds cleanly without a warning, but is it the right thing todo?
>> i.g. rather leave the warning message there and file a bug than just silence
>> the issue. Anyways here is what I have:
>>
>>  From edbeb2b1ee051218f9e5b93fcb8bbdbf1119a6e4 Mon Sep 17 00:00:00 2001
>> From: Justin P. Mattock<justinmattock@gmail.com>
>> Date: Sat, 19 Jun 2010 12:07:32 -0700
>> Subject: [PATCH 5/5] module.c
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   kernel/module.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 8c6b428..765bac5 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1340,7 +1340,7 @@ static void add_usage_links(struct module *mod)
>>   {
>>   #ifdef CONFIG_MODULE_UNLOAD
>>         struct module_use *use;
>> -       int nowarn;
>> +       int nowarn __attribute__((unused));
>
> The `__attribute__((unused))' should be `__used'.
>

I'm confused now. how should I write that out?
(google is not giving me vary many examples on this)

>>
>>         mutex_lock(&module_mutex);
>>         list_for_each_entry(use,&mod->target_list, target_list) {
>> --
>> 1.7.1.rc1.21.gf3bd6
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

Justin P. Mattock

