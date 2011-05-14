Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab1ENBVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 21:21:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40063 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1ENBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 21:21:51 -0400
Date: Fri, 13 May 2011 21:21:24 -0400 (EDT)
Message-Id: <20110513.212124.1730222866632905908.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        ak@linux.intel.com
Subject: Re: [PATCH 5/5] Hook up sysconf syscall for all architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305329059-2017-6-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
	<1305329059-2017-6-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 May 2011 18:21:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Fri, 13 May 2011 16:24:19 -0700

> diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
> index 9d897b6..0b0b362 100644
> --- a/arch/sparc/include/asm/unistd.h
> +++ b/arch/sparc/include/asm/unistd.h
> @@ -404,8 +404,9 @@
>  #define __NR_open_by_handle_at	333
>  #define __NR_clock_adjtime	334
>  #define __NR_syncfs		335
> +#define __NR_sysconf		336
>  
> -#define NR_syscalls		336
> +#define NR_syscalls		337
>  

x86, powerpc, and sparc entries will conflict with already assigned
slots for sys_sendmmsg() in networking tree.

And Eric W. Bierderman has changes that also add system calls to
all architectures for his "setns" namespace changes.
