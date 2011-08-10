Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab1HJBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:16:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52548 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HJBQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <1312937865.1743.29.camel@ymzhang>
References: <1312859345.1743.9.camel@ymzhang>
	<CABqxG0dMcZUw9PVdfpz=V6d05=o+UcWKD_0PyoKir+4i08S+sA@mail.gmail.com>
	<1312880109.1743.26.camel@ymzhang>
	<CABqxG0dGePQYLdcJKcSjoH+=tV89oyb95TFWCKdhb3kCM-T6sQ@mail.gmail.com>
	<1312937865.1743.29.camel@ymzhang>
Date: Wed, 10 Aug 2011 09:16:57 +0800
Message-ID: <CABqxG0d2tYYXndVx3yJe-ZsHVLcOWHet8W7HeinQ9BX5xJ2L9A@mail.gmail.com>
Subject: Re: [PATCH ] printk: add module parameter console_suspend to control console_suspend_enabled
From: Dave Young <hidave.darkstar@gmail.com>
To: yanmin_zhang@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 8:57 AM, Yanmin Zhang
<yanmin_zhang@linux.intel.com> wrote:
> On Tue, 2011-08-09 at 17:59 +0800, Dave Young wrote:
>> Hi,
>>
>> On Tue, Aug 9, 2011 at 4:55 PM, Yanmin Zhang
>> <yanmin_zhang@linux.intel.com> wrote:
>> > On Tue, 2011-08-09 at 16:01 +0800, Dave Young wrote:
>> >> On Tue, Aug 9, 2011 at 11:09 AM, Yanmin Zhang
>> >> <yanmin_zhang@linux.intel.com> wrote:
>> >> > We are enabling some power features on medfield. To test suspend-2-RAM
>> >> > conveniently, we need turn on/off console_suspend_enabled frequently.
>> >> >
>> >> > Below patch adds a module parameter, so users could change it by:
>> >> > /sys/module/printk/parameters/console_suspend_enabled
>> >>
>> >> What about change name to no_console_suspend? Or it will be weird if
>> >> boot kernel with both no_console_suspend and
>> >> printk.console_suspend_enabled set.
>> > Thanks for the comments. How about changing the name to console_suspend?
>> > If changing it to no_console_suspend, we can't map the input to console_suspend_enabled
>> > directly.
>>
>> How about use module_param_cb instead of module_param_named?
> Thanks for the pointer. Indeed, we could use module_param_cb to support the
> input/output parsing. Is it too complicated to use it here? It's better
> to keep simple. The new name console_suspend is clearer than old name.

But it is a little bit confused if the param is not consistant with
no_console_suspend while use in cmdline.  If we have
printk.console_suspend param, then maybe no_console_suspend can be
killed?

Anyway, I will no insist on this.

>
>>
>> >
>> > Below is the new patch.
>> >
>> > ---
>> >
>> > We are enabling some power features on medfield. To test suspend-2-RAM
>> > conveniently, we need turn on/off console_suspend_enabled frequently.
>> >
>> > Below patch adds a module parameter, so users could change it by:
>> > /sys/module/printk/parameters/console_suspend
>> >
>> > Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
>> >
>> > ---
>> >  kernel/printk.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/kernel/printk.c b/kernel/printk.c
>> > index 37dff34..1decef6 100644
>> > --- a/kernel/printk.c
>> > +++ b/kernel/printk.c
>> > @@ -1106,6 +1106,8 @@ static int __init console_suspend_disable(char *str)
>> >        return 1;
>> >  }
>> >  __setup("no_console_suspend", console_suspend_disable);
>> > +module_param_named(console_suspend, console_suspend_enabled,
>> > +               bool, S_IRUGO | S_IWUSR);
>> >
>> >  /**
>> >  * suspend_console - suspend the console subsystem
>> > --
>
>
>



-- 
Regards
Yang RuiRui
