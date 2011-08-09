Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HIIBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:01:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54572 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1HIIBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <1312859345.1743.9.camel@ymzhang>
References: <1312859345.1743.9.camel@ymzhang>
Date: Tue, 9 Aug 2011 16:01:10 +0800
Message-ID: <CABqxG0dMcZUw9PVdfpz=V6d05=o+UcWKD_0PyoKir+4i08S+sA@mail.gmail.com>
Subject: Re: [PATCH ] printk: add module parameter console_suspend_enabled to
 control console_suspend_enabled
From: Dave Young <hidave.darkstar@gmail.com>
To: yanmin_zhang@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 11:09 AM, Yanmin Zhang
<yanmin_zhang@linux.intel.com> wrote:
> We are enabling some power features on medfield. To test suspend-2-RAM
> conveniently, we need turn on/off console_suspend_enabled frequently.
>
> Below patch adds a module parameter, so users could change it by:
> /sys/module/printk/parameters/console_suspend_enabled

What about change name to no_console_suspend? Or it will be weird if
boot kernel with both no_console_suspend and
printk.console_suspend_enabled set.

>
> Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
>
> ---
>  kernel/printk.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 37dff34..ce00f1b 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1106,6 +1106,8 @@ static int __init console_suspend_disable(char *str)
>        return 1;
>  }
>  __setup("no_console_suspend", console_suspend_disable);
> +module_param_named(console_suspend_enabled, console_suspend_enabled,
> +               bool, S_IRUGO | S_IWUSR);
>
>  /**
>  * suspend_console - suspend the console subsystem
> --
> 1.7.1
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
Yang RuiRui
