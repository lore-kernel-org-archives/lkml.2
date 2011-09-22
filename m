Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab1IVH4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:56:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46383 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1IVH4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <1316677848-10193-1-git-send-email-libfetion@gmail.com>
References: <1316677848-10193-1-git-send-email-libfetion@gmail.com>
Date: Thu, 22 Sep 2011 15:56:16 +0800
Message-ID: <CAGn38=2z=6ofLKqxrdSekTE30HVwbjs=oXDQ4k=VJBRvUSj9-w@mail.gmail.com>
Subject: Re: [PATCH] debug_core: Add warn message for CONFIG_DEBUG_RODATA enable
From: Dongdong Deng <libfetion@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        jason.wessel@windriver.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 3:50 PM,  <libfetion@gmail.com> wrote:
> From: Dongdong Deng <libfetion@gmail.com>
>
> The CONFIG_DEBUG_RODATA will limit KGDB/KDB's set breakpoint function,
> and CONFIG_DEBUG_RODATA and CONFIG_KGDB could survive together.
>
> Thus most of new user of KGDB/KDB get the set_breakpoint problem
> caused by CONFIG_DEBUG_RODATA, and them have to send mail to
> kgdb/kdb's mail-list for help.
>
> This patch just adds an extra printk message to warn above case,
> in order to provide some useful diagnostics to kgdb/kdb user.
>
> Signed-off-by: Dongdong Deng <libfetion@gmail.com>
> ---
>  kernel/debug/debug_core.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index bad6786..c2d98c1 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -899,6 +899,11 @@ int kgdb_register_io_module(struct kgdb_io *new_dbg_io_ops)
>        if (kgdb_break_asap)
>                kgdb_initial_breakpoint();
>
> +#ifdef CONFIG_DEBUG_RODATA
> +       printk(KERN_WARNING "kgdb: May need to disable CONFIG_DEBUG_RODATA"
> +                       " in order to set breakpoints.\n");
> +#endif
> +
>        return 0;
>  }
>  EXPORT_SYMBOL_GPL(kgdb_register_io_module);
> --
> 1.7.1
>


Hi Tim,

I am thinking about the case of KGDB, not only the KDB.

How about this patch?  -- add the extra printk message to the debug_core init.

When debug_core init, and  check the CONFIG_DEBUG_RODATA was enabled,
then warn the user that breakpoints will not work...

If it is OK to you,  could you should Signed-off for this patch.  :-)

-Dongdong
