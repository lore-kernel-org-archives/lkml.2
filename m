Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab1LQFLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 00:11:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41620 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1LQFLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 00:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <87bor9qtau.fsf@rustcorp.com.au>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
 <1323731569-20644-18-git-send-email-jim.cromie@gmail.com> <87bor9qtau.fsf@rustcorp.com.au>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 16 Dec 2011 22:10:48 -0700
Message-ID: <CAJfuBxy7W3yZJ1rg3wxuxFbMJ51kogGxJPnBUO4OrVW8iPvOew@mail.gmail.com>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jbaron@redhat.com, greg@kroah.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 5:00 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 12 Dec 2011 16:12:44 -0700, jim.cromie@gmail.com wrote:
>> From: Jim Cromie <jim.cromie@gmail.com>
>>
>> Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
>> from https://lkml.org/lkml/2010/9/15/397
>
> OK, this looks cleaner!
>
> s/modname/doing/ here, since it's a generic callback.
>
> s/modname/doing/ (or /s/modname/unused/).
>
> Same as above.
>
> s/modname/doing/ here too, makes it clear.
>
> ... again....

All done, to be sent shortly.
Thanks


>
>> +/* find & process .dyndbg params (prefixed by modname) in cmdline */
>> +static __init void ddebug_boot_parse_args(void)
>> +{
>
> OK, I don't get why you are doing your own parsing for builtins?
>

After some poking around I didnt want to thrash too much,
and went for Thomas' original approach for builtins.


> Can't you call something from init/main.c:unknown_bootoption()?
>
> If that's too early, I have a patch we're working on which adds
> parameter parsing to each initlevel.
>

It looks too early (unless Ive misunderstood)
dynamic_debug is enabled via arch_initcall

    977 static int __init dynamic_debug_init(void)
    978 {
...
   1018         }
   1019         ddebug_boot_parse_args();
...
   1027 }

   1028 /* Allow early initialization for boot messages via boot param */
   1029 arch_initcall(dynamic_debug_init);
   1030 /* Debugfs setup must be done later */
   1031 module_init(dynamic_debug_init_debugfs);


Do you have a pointer to that patch ?
Is it targetted for v3.3 ?
If so, it sounds like I should aim to use it.

BTW, is this/your desc of arg-processing still accurate/current/complete ?
http://thread.gmane.org/gmane.linux.kernel/767172/focus=767361



> Thanks,
> Rusty.

thank you
Jim Cromie
