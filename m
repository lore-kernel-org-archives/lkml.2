Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab2HWRUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:20:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59814 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899Ab2HWRT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <CADArhcAGV0iTAGirT6XPcVCwOKu-yg_MThk2J+ViK46CLL6Xkw@mail.gmail.com>
References: <CADArhcAGV0iTAGirT6XPcVCwOKu-yg_MThk2J+ViK46CLL6Xkw@mail.gmail.com>
Date: Thu, 23 Aug 2012 23:19:55 +0600
Message-ID: <CADZ9YHjp63UP7Oc2nitGsQB=fAJjGZqSp9P0zDQAA1U+=Q0UJQ@mail.gmail.com>
Subject: Re: [Memory Leak] free kprobe before optimized_kprobe free
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Akhilesh Kumar <akhilesh.lxr@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/12, Akhilesh Kumar <akhilesh.lxr@gmail.com> wrote:
> From a77438899c7295299b59cdca8d1816ea69d6ed8e Mon Sep 17 00:00:00 2001
> From: Akhilesh Kumar <akhilesh.lxr@gmail.com>
> Date: Fri, 10 Aug 2012 14:02:07 +0530
> Subject:[Memory Leak] free kprobe before optimized_kprobe free
>
> Free *ap before *op otherwise ap pointer will be Dangling
>
> Signed-off-by: Akhilesh Kumar <akhilesh.lxr@gmail.com>

An usual way to submit a patch is to mark the subject line with
[patch] tag, not [memory leak].

Thanks,
Rakib

> ---
>  kernel/kprobes.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index c62b854..ff0a97b 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -767,6 +767,7 @@ static __kprobes void
> try_to_optimize_kprobe(struct kprobe *p)
>  	if (!arch_prepared_optinsn(&op->optinsn)) {
>  		/* If failed to setup optimizing, fallback to kprobe */
>  		arch_remove_optimized_kprobe(op);
> +		kfree(ap);
>  		kfree(op);
>  		return;
>  	}
> --
> 1.7.8.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
