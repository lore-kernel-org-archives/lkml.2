Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab0FKWGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:06:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43047 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0FKWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sjiholnhYOP/cSvI+w29yehoml/bZWRV6jp7vISXv8d4H0KIsUck1OEuVlPoGihOPp
         MfvAvCEPy5R5yC3RIQI1xa3/gODCpKl01e0GTk4hdIiZVSow+Xj/QW+YefVKyQGVrPNy
         re/V2Ea7aX08inL03tsOlHDA5JXY7M6k0jqqk=
Message-ID: <4C12B376.4010604@gmail.com>
Date: Fri, 11 Jun 2010 15:06:46 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 5/6]kernel:module.c variable 'nowarn' set but not used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>	<1276288869-16815-6-git-send-email-justinmattock@gmail.com> <AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>
In-Reply-To: <AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 02:17 PM, Geert Uytterhoeven wrote:
> On Fri, Jun 11, 2010 at 22:41, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> The below patch fixes a warning message
>> reported by gcc 4.6.0.
>>
>>   CC      kernel/module.o
>> kernel/module.c: In function 'add_usage_links':
>> kernel/module.c:1343:6: warning: variable 'nowarn' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   kernel/module.c |    8 ++------
>>   1 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 8c6b428..a71027a 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1340,13 +1340,9 @@ static void add_usage_links(struct module *mod)
>>   {
>>   #ifdef CONFIG_MODULE_UNLOAD
>>         struct module_use *use;
>> -       int nowarn;
>> -
>> +
>>         mutex_lock(&module_mutex);
>> -       list_for_each_entry(use,&mod->target_list, target_list) {
>> -               nowarn = sysfs_create_link(use->target->holders_dir,
>> -&mod->mkobj.kobj, mod->name);
>> -       }
>> +       list_for_each_entry(use,&mod->target_list, target_list);
>>         mutex_unlock(&module_mutex);
>>   #endif
>>   }
>
> Also wrong, you removed the creation of the links in sysfs.
>

that's not good..

> The assignment to nowarn was there to avoid another compiler warning,
> as sysfs_create_link() is marked __must_check.
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

alright.. thanks for having a look
and a response. if somebody has a fix
for this then let me know, and I can
test it out over here(I can also try
fixing this as well, but my knowledge
of code only goes so far)..

Justin P. Mattock
