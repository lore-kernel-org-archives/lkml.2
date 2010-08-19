Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0HSX4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:56:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269Ab0HSXzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:55:52 -0400
Date: Thu, 19 Aug 2010 16:55:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] timer: initialize the field slack of timer_list
Message-Id: <20100819165522.7e608703.akpm@linux-foundation.org>
In-Reply-To: <1282027064-7481-1-git-send-email-xiaosuo@gmail.com>
References: <1282027064-7481-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 14:37:44 +0800
Changli Gao <xiaosuo@gmail.com> wrote:

> TIMER_INITIALIZER() should initialize the field slack of timer_list as
> __init_timer() does.
> 

So it should.

> ---
>  include/linux/timer.h |    1 +
>  1 file changed, 1 insertion(+)
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 38cf093..81de484 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -54,6 +54,7 @@ extern struct tvec_base boot_tvec_bases;
>  		.expires = (_expires),				\
>  		.data = (_data),				\
>  		.base = &boot_tvec_bases,			\
> +		.slack = -1,					\
>  		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
>  			__FILE__ ":" __stringify(__LINE__))	\
>  	}

I wonder what the runtime effects of this change are.  Methinks we were
wasting a few cycles in apply_slack()?
