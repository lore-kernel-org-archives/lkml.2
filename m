Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2HGLVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:21:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2HGLV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:21:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] PM: save 8bytes in 'struct dev_pm_info'
Date: Tue, 7 Aug 2012 13:27:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <1344308278-23211-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1344308278-23211-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071327.19648.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 07, 2012, Ming Lei wrote:
> On ARMv7, sizeof(struct dev_pm_info) becomes 344Bytes from 352Bytes
> after applying the patch which only changes fields' order, so we can
> save 8bytes per device. Nothing in behaviour changed.
> 
> GCC: gcc version 4.5.1
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

While I have no fundamental objections against this patch, I see that it
will conflict with some other patches changing struct dev_pm_info.

For this reason, if I apply it at all, I'll do that when my pull request for
v3.7 is practically ready.

Thanks,
Rafael


> ---
>  include/linux/pm.h |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index f067e60..f116d40 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -505,11 +505,6 @@ struct pm_subsys_data {
>  
>  struct dev_pm_info {
>  	pm_message_t		power_state;
> -	unsigned int		can_wakeup:1;
> -	unsigned int		async_suspend:1;
> -	bool			is_prepared:1;	/* Owned by the PM core */
> -	bool			is_suspended:1;	/* Ditto */
> -	bool			ignore_children:1;
>  	spinlock_t		lock;
>  #ifdef CONFIG_PM_SLEEP
>  	struct list_head	entry;
> @@ -519,13 +514,12 @@ struct dev_pm_info {
>  #else
>  	unsigned int		should_wakeup:1;
>  #endif
> +	unsigned int		can_wakeup:1;
> +	unsigned int		async_suspend:1;
> +	bool			is_prepared:1;	/* Owned by the PM core */
> +	bool			is_suspended:1;	/* Ditto */
> +	bool			ignore_children:1;
>  #ifdef CONFIG_PM_RUNTIME
> -	struct timer_list	suspend_timer;
> -	unsigned long		timer_expires;
> -	struct work_struct	work;
> -	wait_queue_head_t	wait_queue;
> -	atomic_t		usage_count;
> -	atomic_t		child_count;
>  	unsigned int		disable_depth:3;
>  	unsigned int		idle_notification:1;
>  	unsigned int		request_pending:1;
> @@ -538,6 +532,12 @@ struct dev_pm_info {
>  	unsigned int		timer_autosuspends:1;
>  	enum rpm_request	request;
>  	enum rpm_status		runtime_status;
> +	struct timer_list	suspend_timer;
> +	unsigned long		timer_expires;
> +	struct work_struct	work;
> +	wait_queue_head_t	wait_queue;
> +	atomic_t		usage_count;
> +	atomic_t		child_count;
>  	int			runtime_error;
>  	int			autosuspend_delay;
>  	unsigned long		last_busy;
> 

