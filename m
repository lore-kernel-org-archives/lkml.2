Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0EPDhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 23:37:39 -0400
Received: from in.cluded.net ([195.159.98.120]:40168 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0EPDhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 23:37:38 -0400
Message-ID: <4BEF677A.2030003@uw.no>
Date: Sun, 16 May 2010 03:33:14 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/10] tty: implement BTM as mutex instead of BKL
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <1273957196-13768-11-git-send-email-arnd@arndb.de>
In-Reply-To: <1273957196-13768-11-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> diff --git a/drivers/char/tty_mutex.c b/drivers/char/tty_mutex.c
> new file mode 100644
> index 0000000..f66dfdf
> --- /dev/null
> +++ b/drivers/char/tty_mutex.c
> @@ -0,0 +1,47 @@
> +/*
> + * drivers/char/tty_lock.c
> + */
> +#include <linux/tty.h>
> +#include <linux/module.h>
> +#include <linux/kallsyms.h>
> +#include <linux/semaphore.h>
> +#include <linux/sched.h>
> +
> +/*
> + * The 'big tty semaphore'

Referred to as Big TTY Mutex or BTM elsewhere.


> + * This mutex is taken and released by tty_lock() and tty_unlock(),
> + * replacing the older big kernel mutex.

big kernel lock, or BKL?


> + * It can no longer be taken recursively, and does not get
> + * released implicitly while sleeping.
> + *
> + * Don't use in new code.
> + */
> +static DEFINE_MUTEX(big_tty_mutex);
> +struct task_struct *__big_tty_mutex_owner;
> +EXPORT_SYMBOL_GPL(__big_tty_mutex_owner);

> +config TTY_MUTEX
> +	bool "Use a mutex instead of BKL for TTY locking"
> +	depends on EXPERIMENTAL && SMP
> +	help
> +	  The TTY subsystem traditionally depends on the big kernel lock
> +	  for serialization. Saying Y here replaces the BKL with the Big
> +	  TTY Mutex (BTM).
> +	  Building a kernel without the BKL is only possible with TTY_MUTEX
> +	  enabled.
> +


Daniel K.
