Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab2HBESa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 00:18:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51704 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2HBES3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 00:18:29 -0400
MIME-Version: 1.0
In-Reply-To: <1343878276-4108-1-git-send-email-fdu@windriver.com>
References: <1343878276-4108-1-git-send-email-fdu@windriver.com>
Date: Wed, 1 Aug 2012 21:18:28 -0700
Message-ID: <CAJiQ=7Abc2sR2E2FXmeTr_Hc+CWH+J25=juB3wL172Tn6-PYuA@mail.gmail.com>
Subject: Re: [PATCH] MIPS: oops when show backtrace of all active cpu
From: Kevin Cernekee <cernekee@gmail.com>
To: Fan Du <fdu@windriver.com>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, vincent wen <vincentwenlinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 8:31 PM, Fan Du <fdu@windriver.com> wrote:
> show_backtrace must have an valid task when calling unwind_stack,
> so fix it by checking first.
[...]
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -151,6 +151,10 @@ static void show_backtrace(struct task_struct *task, const struct pt_regs *regs)
>                 show_raw_backtrace(sp);
>                 return;
>         }
> +
> +       if (task == NULL)
> +               task = current;
> +
>         printk("Call Trace:\n");
>         do {
>                 print_ip_sym(pc);

FYI, a slightly different version of this change was accepted:

https://patchwork.linux-mips.org/patch/3524/
