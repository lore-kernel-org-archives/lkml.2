Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1AXQD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:03:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58732 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1AXQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:03:57 -0500
Date: Mon, 24 Jan 2011 08:03:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: sysrq -- ensure sysrq_enabled and
 __sysrq_enabled are consistent
Message-Id: <20110124080335.3e6a17e2.randy.dunlap@oracle.com>
In-Reply-To: <1295877972-363-2-git-send-email-apw@canonical.com>
References: <1295877972-363-1-git-send-email-apw@canonical.com>
	<1295877972-363-2-git-send-email-apw@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 14:06:12 +0000 Andy Whitcroft wrote:

> Currently sysrq_enabled and __sysrq_enabled are initialised separatly
> and inconsitantly, leading to sysrq being actually enabled by reported
> as not enabled in sysfs.  The first change to the sysfs configurable
> synchronises these two:
> 
>     static int __read_mostly sysrq_enabled = 1;
>     static int __sysrq_enabled;
> 
> Add a common define to carry the default for these preventing them becoming
> out of sync again.  Default this to 1 to mirror previous behaviour.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/tty/sysrq.c   |    2 +-
>  include/linux/sysrq.h |    3 +++
>  kernel/sysctl.c       |    3 ++-
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index c556ed9..8e0dd25 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -46,7 +46,7 @@
>  #include <asm/irq_regs.h>
>  
>  /* Whether we react on sysrq keys or just ignore them */
> -static int __read_mostly sysrq_enabled = 1;
> +static int __read_mostly sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
>  static bool __read_mostly sysrq_always_enabled;
>  
>  static bool sysrq_on(void)
> diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
> index 387fa7d..7faf933 100644
> --- a/include/linux/sysrq.h
> +++ b/include/linux/sysrq.h
> @@ -17,6 +17,9 @@
>  #include <linux/errno.h>
>  #include <linux/types.h>
>  
> +/* Enable/disable SYSRQ support by default (0==no, 1==yes). */
> +#define SYSRQ_DEFAULT_ENABLE	1
> +
>  /* Possible values of bitmask for enabling sysrq functions */
>  /* 0x0001 is reserved for enable everything */
>  #define SYSRQ_ENABLE_LOG	0x0002
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index bc86bb3..0f1bd83 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -170,7 +170,8 @@ static int proc_taint(struct ctl_table *table, int write,
>  #endif
>  
>  #ifdef CONFIG_MAGIC_SYSRQ
> -static int __sysrq_enabled; /* Note: sysrq code ises it's own private copy */
> +/* Note: sysrq code uses it's own private copy */

                            its

Meta-comment:  There's no good reason to have patch 0/1.  Just put all of the
patch description in patch 1/1.


> +static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
>  
>  static int sysrq_sysctl_handler(ctl_table *table, int write,
>  				void __user *buffer, size_t *lenp,
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
