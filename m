Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1CCDNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:13:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab1CCDNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:13:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 3/4] exec: unify do_execve/compat_do_execve code
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
In-Reply-To: <20110302162753.GD26810@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162753.GD26810@redhat.com>
Message-Id: <20110303120915.B951.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 12:13:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1510,11 +1528,27 @@ int do_execve(const char *filename,
>  	const char __user *const __user *__envp,
>  	struct pt_regs *regs)
>  {
> -	struct conditional_ptr argv = { .native = __argv };
> -	struct conditional_ptr envp = { .native = __envp };
> +	struct conditional_ptr argv = { .ptr.native = __argv };
> +	struct conditional_ptr envp = { .ptr.native = __envp };
>  	return do_execve_common(filename, argv, envp, regs);
>  }
>  
> +#ifdef CONFIG_COMPAT
> +int compat_do_execve(char *filename,
> +	compat_uptr_t __user *__argv,
> +	compat_uptr_t __user *__envp,
> +	struct pt_regs *regs)
> +{
> +	struct conditional_ptr argv = {
> +		.is_compat = true, .ptr.compat = __argv,
> +	};

Please don't mind to compress a line.

	struct conditional_ptr argv = {
		.is_compat = true,
		.ptr.compat = __argv,
	};

is more good readability.


Other parts looks very good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



