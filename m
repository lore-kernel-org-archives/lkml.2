Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1IMQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:31:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50030 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab1IMQbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:31:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110913162023.GA23759@codeaurora.org>
References: <20110913162023.GA23759@codeaurora.org>
Date: Tue, 13 Sep 2011 18:31:14 +0200
Message-ID: <CAL4Wiioh69CYAnbJnCuQM8cs19eWCsXF8p_rwAswBWQfe5+rWQ@mail.gmail.com>
Subject: Re: [PATCH] Janitor: Typo in stack debug code
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/13 Linas Vepstas (Code Aurora) <linas@codeaurora.org>:
>
> In the debug routine check_stack_usage(), free stack space is counted
> in units of (unsigned long), not bytes.  Make this clear when printing.
>
> It seems easiest to just change the message, instead of multiplying
> by sizeof(unsigned long).
>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>
>
> ---
>
> ===================================================================
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -888,7 +888,7 @@ static void check_stack_usage(void)
>
>        spin_lock(&low_water_lock);
>        if (free < lowest_to_date) {
> -               printk(KERN_WARNING "%s used greatest stack depth: %lu bytes "
> +               printk(KERN_WARNING "%s used greatest stack depth: %lu words "
>                                "left\n",
>                                current->comm, free);
>                lowest_to_date = free;
>
>
>
>

Thats not true, everything is fine.

dmesg | grep stack
[    1.564907] kworker/u:0 used greatest stack depth: 5592 bytes left
[    2.467909] modprobe used greatest stack depth: 5576 bytes left
[    2.483228] exe used greatest stack depth: 5552 bytes left
[    2.489430] all_generic_ide used greatest stack depth: 5496 bytes left
[    2.524731] scsi_id used greatest stack depth: 5440 bytes left
[    2.643103] blkid used greatest stack depth: 4768 bytes left
[    4.232051] exe used greatest stack depth: 4320 bytes left
[    4.761443] stty used greatest stack depth: 3784 bytes left
[    6.011566] modprobe used greatest stack depth: 3664 bytes left
[    6.011681] modprobe used greatest stack depth: 3184 bytes left
[  339.890273] nroff used greatest stack depth: 3032 bytes left
