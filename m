Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1CCAGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:06:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1CCAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:06:20 -0500
Date: Wed, 2 Mar 2011 16:06:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Wessfeldt <johan.wessfeldt@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcheck: Correction to a missing return value from
 misc_register
Message-Id: <20110302160601.a8936c21.akpm@linux-foundation.org>
In-Reply-To: <1298891944-21364-1-git-send-email-johan.wessfeldt@gmail.com>
References: <1298891944-21364-1-git-send-email-johan.wessfeldt@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 12:19:04 +0100
Johan Wessfeldt <johan.wessfeldt@gmail.com> wrote:

> Return value from misc_register was not handled correctly
> in mcheck_init_device()
> 
> Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d916183..7274a11 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2140,7 +2140,7 @@ static __init int mcheck_init_device(void)
>  	}
>  
>  	register_hotcpu_notifier(&mce_cpu_notifier);
> -	misc_register(&mce_log_device);
> +	err = misc_register(&mce_log_device);
>  
>  	return err;
>  }

It should be fixed, but not that way.  If misc_register() fails here,
mcheck_init_device() should undo all the things which it just did.

And the memory leak which occurs if sysdev_class_register() fails and
the memory and other resource leaks which occur if mce_create_device()
fails should be fixed too.

mcheck_init_device() a rather optimistic function.
