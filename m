Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0KSGYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 01:24:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32908 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0KSGYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 01:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=je1lMwXE0dGRrgXC/yL67CWcvyFECpLF7IgOevBP9fqYf/zbRD6ShhgmfiykA1l36i
         xvT9YSvSV6fUnCUUlXTbu0xP5DrsQbrLTzL7uFyqQSVJYW7YUj1BrOo8jgX6FYkt0dxJ
         dOKJ/DdXTKg1xbt8AKpVBlQt69M79gzP8c3V8=
MIME-Version: 1.0
In-Reply-To: <1290144410-30981-1-git-send-email-gadiyar@ti.com>
References: <1290144410-30981-1-git-send-email-gadiyar@ti.com>
Date: Fri, 19 Nov 2010 12:24:21 +0600
Message-ID: <AANLkTik9T_HaciZRntet9nx5-UUcKs23fNpmN0vCam2G@mail.gmail.com>
Subject: Re: [PATCH] kernel/cpu.c - fix build warning
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/10, Anand Gadiyar <gadiyar@ti.com> wrote:
> Patch "sched: Simplify cpu-hot-unplug task migration" in
> linux-next as of 20101119 introduced the following compile
> warning. Fix this.
>
>   CC      kernel/cpu.o
> kernel/cpu.c: In function 'take_cpu_down':
> kernel/cpu.c:200: warning: unused variable 'cpu'
>
It's been already fixed by http://lkml.org/lkml/2010/11/18/314.


thanks,
rakib

> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> Okay with me to fold this into the original patch if that's
> still possible.
>
>  kernel/cpu.c |    1 -
>  1 file changed, 1 deletion(-)
>
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -197,7 +197,6 @@ struct take_cpu_down_param {
>  static int __ref take_cpu_down(void *_param)
>  {
>  	struct take_cpu_down_param *param = _param;
> -	unsigned int cpu = (unsigned long)param->hcpu;
>  	int err;
>
>  	/* Ensure this CPU doesn't handle any more interrupts. */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
