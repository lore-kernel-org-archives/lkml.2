Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1GHSp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:45:56 -0400
Received: from smtp03.bis6.us.blackberry.com ([74.82.85.3]:12518 "EHLO
	smtp03.bis6.us.blackberry.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548Ab1GHSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:45:55 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jul 2011 14:45:55 EDT
X-rim-org-msg-ref-id: 1652523982
Message-ID: <1652523982-1310150159-cardhu_decombobulator_blackberry.rim.net-183695056-@b1.c19.bise6.blackberry>
Reply-To: drosenberg@vsecurity.com
X-Priority: Normal
Sensitivity: Normal
Importance: Normal
Subject: Re: [Security] [PATCH] xtensa: prevent arbitrary read in ptrace
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: chris@zankel.net, security@kernel.org, linux-kernel@vger.kernel.org,
        "Oleg Nesterov" <oleg@redhat.com>
From: "Dan Rosenberg" <drosenberg@vsecurity.com>
Date: Fri, 8 Jul 2011 18:35:56 +0000
Content-Type: text/plain
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p68Ik4rv001863

Sorry for the top post and any email mangling (mobile).

I only used EIO to mirror the existing behavior in ptrace_getxregs(). EFAULT seems better.

-Dan

------Original Message------
From: Andrew Morton
To: Dan Rosenberg
Cc: chris@zankel.net
Cc: security@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov
Subject: Re: [Security] [PATCH] xtensa: prevent arbitrary read in ptrace
Sent: Jul 8, 2011 2:27 PM

On Thu, 07 Jul 2011 20:03:54 -0400
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> Prevent an arbitrary kernel read. Check the user pointer with
> access_ok() before copying data in.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Cc: stable@kernel.org
> ---
>  arch/xtensa/kernel/ptrace.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
> index c72c947..ddce75e 100644
> --- a/arch/xtensa/kernel/ptrace.c
> +++ b/arch/xtensa/kernel/ptrace.c
> @@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
>  	elf_xtregs_t *xtregs = uregs;
>  	int ret = 0;
>  
> +	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
> +		return -EIO;

This should be -EFAULT, methinks?

> +
>  #if XTENSA_HAVE_COPROCESSORS
>  	/* Flush all coprocessors before we overwrite them. */
>  	coprocessor_flush_all(ti);ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
