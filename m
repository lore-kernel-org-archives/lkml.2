Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0KXNTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:19:39 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40142 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab0KXNTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hlxZrr4VJkkCnjAfKwuy1o3W6rfoz4k8Z6SS7KQigrGD1JbNHUOnwYmkAjSyeFfu7m
         +rgkNi8iE4pGS42WgFStKljr1GrWFXW2KqFYgcolr7CL3Cu9wq51cG1jzrQluaRzOX7X
         ljliNU0dcRJR/atAIkSmFeJIeVqan5AnrdakQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
Date: Wed, 24 Nov 2010 14:19:35 +0100
Message-ID: <AANLkTik0iWzP4KwVwpY4bDJuyZnQTFnW0Q5pj3TM-s_O@mail.gmail.com>
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Rakib Mullick <rakib.mullick@gmail.com>:
> With allnoconfig, bp becomes unused. So put bp into defination of
> CONFIG_FRAME_POINTER.
>
> arch/x86/kernel/dumpstack.c: In function ‘dump_stack’:
> arch/x86/kernel/dumpstack.c:200: warning: unused variable ‘bp’
>
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
>
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 8474c99..fc5a253 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -197,10 +197,10 @@ void show_stack(struct task_struct *task,
> unsigned long *sp)
>  */
>  void dump_stack(void)
>  {
> -       unsigned long bp = 0;
>        unsigned long stack;
>
>  #ifdef CONFIG_FRAME_POINTER
> +       unsigned long bp = 0;
>        if (!bp)
>                get_bp(bp);
>  #endif
>

Looks like you can even remove that block. bp is not used any more in
this function.
get_bp() was only loading bp but did not make any use of it.

Thanks.
