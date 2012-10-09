Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2JIVqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:46:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2JIVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:46:18 -0400
Date: Tue, 9 Oct 2012 14:46:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] lglock: make the per_cpu locks static
Message-Id: <20121009144617.7d7862b1.akpm@linux-foundation.org>
In-Reply-To: <1349754403-4798-2-git-send-email-laijs@cn.fujitsu.com>
References: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
	<1349754403-4798-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012 11:46:39 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> The per_cpu locks are not used outside nor exported.
> Add a "static" linkage keyword to it.

I think a better description is:

: The per_cpu locks are not used outside the file which contains the
: DEFINE_LGLOCK(), so we can make these symbols static.

> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@ -49,7 +49,7 @@ struct lglock {
>  };
>  
>  #define DEFINE_LGLOCK(name)						\
> -	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)			\
> +	static DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)		\
>  	= __ARCH_SPIN_LOCK_UNLOCKED;					\
>  	struct lglock name = { .lock = &name ## _lock }
>  
> -- 
> 1.7.4.4
