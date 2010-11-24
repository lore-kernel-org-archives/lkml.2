Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0KXKEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:04:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15240 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0KXKEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:04:54 -0500
Date: Wed, 24 Nov 2010 10:57:10 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
In-Reply-To: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-432350309-1290592630=:23994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-432350309-1290592630=:23994
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Wed, 24 Nov 2010, Rakib Mullick wrote:

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
>   */
>  void dump_stack(void)
>  {
> -	unsigned long bp = 0;
>  	unsigned long stack;
> 
>  #ifdef CONFIG_FRAME_POINTER
> +	unsigned long bp = 0;
>  	if (!bp)
>  		get_bp(bp);
>  #endif

So, now the bp variable does not exist at all if CONFIG_FRAME_POINTER is 
not defined.
That's going to make this line :

          show_trace(NULL, NULL, &stack, bp);

found further down in the dump_stack() function, quite unhappy.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-432350309-1290592630=:23994--
