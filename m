Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1DNRJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:09:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52130 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1DNRJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oS3+R62Krw8RTp32/gn7zg/gJ7asIGsHpd9rxfaD7g89c4uX3J7r2ssb6eVKCbXpwi
         0ehu8ofiWqRzHfWtUG9LCIeRzNQVGLk0tH87C6ldb8d7mrLKRtEyDm89h2ddK2wcaYRd
         BiP9DDSsJrYu8xNamyqQA+D/3WuyUW9q62bDM=
Subject: Re: [PATCH] futex: set FLAGS_HAS_TIMEOUT during demux for
 FUTEX_WAIT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <39ac45dcef66930ae01cb5c632446a76447935b2.1302800313.git.dvhart@linux.intel.com>
References: <39ac45dcef66930ae01cb5c632446a76447935b2.1302800313.git.dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 19:09:09 +0200
Message-ID: <1302800949.3248.42.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 09:58 -0700, Darren Hart a écrit :
> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> restart futex_wait() without a timeout after a signal.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Tim Smith <tsmith201104@yahoo.com>
> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> ---
>  kernel/futex.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index bda4157..6eac6b6 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2589,6 +2589,9 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>  			return -ENOSYS;
>  	}
>  
> +	if (timeout)
> +		flags |= FLAGS_HAS_TIMEOUT;
> +
>  	switch (cmd) {
>  	case FUTEX_WAIT:
>  		val3 = FUTEX_BITSET_MATCH_ANY;



Hmm, could you please add in the changelog the commit id introducing the
bug ?

I suspect its b41277dc7a18ee332d, added in 2.6.38 ?

Thanks


