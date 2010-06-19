Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0FSTps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:45:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56311 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0FSTpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kd6lHhk5AK3VBqx0IcwUZHZu2SgJxKE4kq78qw8pRG+YqV6lJ6Mh7H2qY5MAjFmh1K
         iA5FZVDFMRH5MA8rV9M9YEbmchFwzUfLUNQvO53Rc7fFa/oR9rmO//xoH5RH0ON0lys4
         Bs4+8uuZO9Cpo/31mh9xs+Pba/4bFYNU604+Q=
MIME-Version: 1.0
In-Reply-To: <4C1D160D.5030303@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
	<1276288869-16815-6-git-send-email-justinmattock@gmail.com>
	<AANLkTilZLOGXpZxHUklA8iHMj8HsJap2BvWMrWMmeyu3@mail.gmail.com>
	<4C1C4FDE.2090101@gmail.com>
	<AANLkTin5ovxSSsIM-1R-u7mmoqxp8UnxgtkuVJfZU2ES@mail.gmail.com>
	<4C1D160D.5030303@gmail.com>
Date: Sat, 19 Jun 2010 21:45:45 +0200
X-Google-Sender-Auth: S-AjvhkhvdHcalqvAPcQzPAM4xY
Message-ID: <AANLkTikOP99vtHOmfLZ05TkGFK8ffVNSSDoBvgCaIMCi@mail.gmail.com>
Subject: Re: [PATCH 5/6]kernel:module.c variable 'nowarn' set but not used
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 21:10, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 06/19/2010 01:08 AM, Geert Uytterhoeven wrote:
>>
>> On Sat, Jun 19, 2010 at 07:04, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:
>>>>
>>>> Also wrong, you removed the creation of the links in sysfs.
>>>>
>>>> The assignment to nowarn was there to avoid another compiler warning,
>>>> as sysfs_create_link() is marked __must_check.
>>>
>>> I also went back to this one and made the following changes.. let me know
>>> if
>>> it's wrong etc..
>>>
>>>  From 4f45beed80627d2bb32fb021bb6d22d88089557b Mon Sep 17 00:00:00 2001
>>> From: Justin P. Mattock<justinmattock@gmail.com>
>>> Date: Fri, 18 Jun 2010 22:01:07 -0700
>>> Subject: [PATCH 5/5] module.c
>>>  Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>
>>> ---
>>>  kernel/module.c |    3 +--
>>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/module.c b/kernel/module.c
>>> index 8c6b428..48fc5c8 100644
>>> --- a/kernel/module.c
>>> +++ b/kernel/module.c
>>> @@ -1340,11 +1340,10 @@ static void add_usage_links(struct module *mod)
>>>  {
>>>  #ifdef CONFIG_MODULE_UNLOAD
>>>        struct module_use *use;
>>> -       int nowarn;
>>>
>>>        mutex_lock(&module_mutex);
>>>        list_for_each_entry(use,&mod->target_list, target_list) {
>>> -               nowarn = sysfs_create_link(use->target->holders_dir,
>>> +               sysfs_create_link(use->target->holders_dir,
>>>                                           &mod->mkobj.kobj, mod->name);
>>>        }
>>>        mutex_unlock(&module_mutex);
>>> --
>>> 1.7.1.rc1.21.gf3bd6
>>>
>>> if it looks good, then I can resend it out.
>>
>> Have you compile-tested this?
>> As sysfs_create_link() is marked __must_check, that will cause another
>> compiler
>> warning, but only if CONFIG_SYSFS=y.
>>
>> Perhaps you can just mark the nowarn variable __unused?
>
>
> o.k. this builds cleanly without a warning, but is it the right thing todo?
> i.g. rather leave the warning message there and file a bug than just silence
> the issue. Anyways here is what I have:
>
> From edbeb2b1ee051218f9e5b93fcb8bbdbf1119a6e4 Mon Sep 17 00:00:00 2001
> From: Justin P. Mattock <justinmattock@gmail.com>
> Date: Sat, 19 Jun 2010 12:07:32 -0700
> Subject: [PATCH 5/5] module.c
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  kernel/module.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 8c6b428..765bac5 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1340,7 +1340,7 @@ static void add_usage_links(struct module *mod)
>  {
>  #ifdef CONFIG_MODULE_UNLOAD
>        struct module_use *use;
> -       int nowarn;
> +       int nowarn __attribute__((unused));

The `__attribute__((unused))' should be `__used'.

>
>        mutex_lock(&module_mutex);
>        list_for_each_entry(use, &mod->target_list, target_list) {
> --
> 1.7.1.rc1.21.gf3bd6

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
