Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2DBSiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:38:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64666 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2DBSiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:38:11 -0400
MIME-Version: 1.0
In-Reply-To: <1333391754.2960.70.camel@laptop>
References: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com>
	<alpine.LFD.2.02.1204011935190.2542@ionos>
	<CA+1xoqeTJu-uaaOCek5Y5ZKam83ePoRNFdxLcqdonYxok-BkhA@mail.gmail.com>
	<alpine.LFD.2.02.1204021111070.2542@ionos>
	<1333391754.2960.70.camel@laptop>
Date: Mon, 2 Apr 2012 21:38:10 +0300
X-Google-Sender-Auth: MwohfPfMoi16v_LPw8s-6FGd3GY
Message-ID: <CAOJsxLHZbi+XTFsTtqZqHAm4Gz1d7-01+L6sgex3ZrYDXyjVPg@mail.gmail.com>
Subject: Re: [PATCH] debugobjects: Use GFP_ATOMIC to allocate when initializing
From: Pekka Enberg <penberg@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <levinsasha928@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 9:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Something like so?
>
> ---
>  kernel/lockdep.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index ea9ee45..a028ba9 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2718,6 +2718,13 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
>  {
>        struct task_struct *curr = current;
>
> +       /*
> +        * We do GFP_KERNEL allocations with IRQs disabled during system
> +        * bringup..
> +        */
> +       if (unlikely(system_state != SYSTEM_RUNNING))
> +               return;
> +
>        if (unlikely(!debug_locks))
>                return;

Yes, please.

Acked-by: Pekka Enberg <penberg@kernel.org>
