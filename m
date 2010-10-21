Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0JUWCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:02:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932571Ab0JUWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:02:53 -0400
Date: Thu, 21 Oct 2010 15:02:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Message-Id: <20101021150250.f6499506.akpm@linux-foundation.org>
In-Reply-To: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 13:27:15 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> If the arch doesn't provide atomic64 functionality (there are quite a
> few), then don't bother trying to build this test.
> 

I don't get it.  If the arch doesn't implement atomic64 then this file
will get zillions of build errors, won't it?

> diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
> index 250ed11..0ac1a66 100644
> --- a/lib/atomic64_test.c
> +++ b/lib/atomic64_test.c
> @@ -12,6 +12,8 @@
>  #include <linux/kernel.h>
>  #include <asm/atomic.h>
>  
> +#ifdef ATOMIC64_INIT

hm, that's a bit lazy.  It should really use a CONFIG_HAVE_ thing.  What
a pita.

>  #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
>  static __init int test_atomic64(void)
>  {
> @@ -164,3 +166,5 @@ static __init int test_atomic64(void)
>  }
>  
>  core_initcall(test_atomic64);
> +
> +#endif
> -- 
> 1.7.3.1
