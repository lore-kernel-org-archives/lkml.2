Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0CYSkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:40:05 -0400
Received: from claw.goop.org ([74.207.240.146]:40012 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab0CYSkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:40:03 -0400
Message-ID: <4BABAE00.8010606@goop.org>
Date: Thu, 25 Mar 2010 11:40:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 3/3 -next] xen: fix build when SYSRQ is disabled
References: <20100325173853.f06a7b33.sfr@canb.auug.org.au> <4BABAB8C.2070104@oracle.com>
In-Reply-To: <4BABAB8C.2070104@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 11:29 AM, Randy Dunlap wrote:
> From: Randy Dunlap<randy.dunlap@oracle.com>
>
> Fix build error when CONFIG_MAGIC_SYSRQ is not enabled:
>
> drivers/xen/manage.c:223: error: implicit declaration of function 'handle_sysrq'
>    

Yep, looks fine.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

     J
> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
> Cc: Jeremy Fitzhardinge<jeremy@xensource.com>
> Cc: Chris Wright<chrisw@sous-sol.org>
> ---
>   drivers/xen/manage.c |   14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> --- linux-next-20100325.orig/drivers/xen/manage.c
> +++ linux-next-20100325/drivers/xen/manage.c
> @@ -194,6 +194,7 @@ static void shutdown_handler(struct xenb
>   	kfree(str);
>   }
>
> +#ifdef CONFIG_MAGIC_SYSRQ
>   static void sysrq_handler(struct xenbus_watch *watch, const char **vec,
>   			  unsigned int len)
>   {
> @@ -223,15 +224,16 @@ static void sysrq_handler(struct xenbus_
>   		handle_sysrq(sysrq_key, NULL);
>   }
>
> -static struct xenbus_watch shutdown_watch = {
> -	.node = "control/shutdown",
> -	.callback = shutdown_handler
> -};
> -
>   static struct xenbus_watch sysrq_watch = {
>   	.node = "control/sysrq",
>   	.callback = sysrq_handler
>   };
> +#endif
> +
> +static struct xenbus_watch shutdown_watch = {
> +	.node = "control/shutdown",
> +	.callback = shutdown_handler
> +};
>
>   static int setup_shutdown_watcher(void)
>   {
> @@ -243,11 +245,13 @@ static int setup_shutdown_watcher(void)
>   		return err;
>   	}
>
> +#ifdef CONFIG_MAGIC_SYSRQ
>   	err = register_xenbus_watch(&sysrq_watch);
>   	if (err) {
>   		printk(KERN_ERR "Failed to set sysrq watcher\n");
>   		return err;
>   	}
> +#endif
>
>   	return 0;
>   }
>    

