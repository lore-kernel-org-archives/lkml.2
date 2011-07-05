Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1GELpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:45:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58482 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab1GELpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:45:13 -0400
Message-ID: <4E12F942.90504@monstr.eu>
Date: Tue, 05 Jul 2011 13:45:06 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze, exec: remove redundant set_fs(USER_DS)
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com> <1307711399-7929-1-git-send-email-minipli@googlemail.com>
In-Reply-To: <1307711399-7929-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Krause wrote:
> The address limit is already set in flush_old_exec() so this
> set_fs(USER_DS) is redundant.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  arch/microblaze/kernel/process.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
> index 968648a..dbb8124 100644
> --- a/arch/microblaze/kernel/process.c
> +++ b/arch/microblaze/kernel/process.c
> @@ -237,7 +237,6 @@ unsigned long get_wchan(struct task_struct *p)
>  /* Set up a thread for executing a new program */
>  void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp)
>  {
> -	set_fs(USER_DS);
>  	regs->pc = pc;
>  	regs->r1 = usp;
>  	regs->pt_mode = 0;

Andrew has added it to his queue. I have tested and applied too.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
