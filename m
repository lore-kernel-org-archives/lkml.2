Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1AFSzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:55:44 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40620 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201Ab1AFSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:55:42 -0500
Subject: Re: [PATCH] PM: fix suspend_set_ops() to take const pointer
From: Kevin Hilman <khilman@ti.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1294273373-8967-1-git-send-email-khilman@ti.com>
References: <1294273373-8967-1-git-send-email-khilman@ti.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments, Inc.
Date: Thu, 06 Jan 2011 10:55:37 -0800
Message-ID: <1294340137.328.6.camel@vence>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 16:22 -0800, Kevin Hilman wrote:
> checkpatch warns that pointers for certain structs should be const,
> and platform_suspend_ops is one of those structs.  If you follow this
> suggestion you trade a checkpatch warning for a compiler warning of
> the form:
> 
>    warning: passing argument 1 of 'suspend_set_ops' discards qualifiers from pointer target type
> 
> Fix suspend_set_ops() to take a const pointer so everyone expects
> const.
> 
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
> Applies to v2.6.37, but also applies cleanly to suspend-2.6/linux-next

Oops, plese disregard.  This is already fixed in linux-next.

Kevin

>  include/linux/suspend.h |    4 ++--
>  kernel/power/suspend.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 2669751..bb98383 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -122,7 +122,7 @@ struct platform_suspend_ops {
>   * suspend_set_ops - set platform dependent suspend operations
>   * @ops: The new suspend operations to set.
>   */
> -extern void suspend_set_ops(struct platform_suspend_ops *ops);
> +extern void suspend_set_ops(const struct platform_suspend_ops *ops);
>  extern int suspend_valid_only_mem(suspend_state_t state);
>  
>  /**
> @@ -147,7 +147,7 @@ extern int pm_suspend(suspend_state_t state);
>  #else /* !CONFIG_SUSPEND */
>  #define suspend_valid_only_mem	NULL
>  
> -static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
> +static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
>  static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
>  #endif /* !CONFIG_SUSPEND */
>  
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index ecf7705..0c0af3d 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -36,7 +36,7 @@ static struct platform_suspend_ops *suspend_ops;
>   *	suspend_set_ops - Set the global suspend method table.
>   *	@ops:	Pointer to ops structure.
>   */
> -void suspend_set_ops(struct platform_suspend_ops *ops)
> +void suspend_set_ops(const struct platform_suspend_ops *ops)
>  {
>  	mutex_lock(&pm_mutex);
>  	suspend_ops = ops;


