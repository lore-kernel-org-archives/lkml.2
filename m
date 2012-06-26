Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2FZGmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:42:31 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48592 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293Ab2FZGm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:42:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsEMAClZ6U9bdWOb/2dsb2JhbABEhVqoICKIEYEHghgBAQUjBFIQCxgCAiYCAlcGE4gPpX2TGIEgjwWBEgOlNIJh
X-IronPort-AV: E=Sophos;i="4.77,476,1336341600"; 
   d="scan'208";a="1008846128"
Message-ID: <1340692980.4177.6.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] drivers: staging: android: binder.c: fix printk macros
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Sherwin Soltani <sherwin@wybc.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        swetland@google.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 08:43:00 +0200
In-Reply-To: <1340690430-13016-1-git-send-email-sherwin@wybc.com>
References: <1340690430-13016-1-git-send-email-sherwin@wybc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 02:00 -0400, Sherwin Soltani wrote:
> Change printk() messages to pr_* macros.
> 
> Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
> ---
>  drivers/staging/android/binder.c |   54 +++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index c283212..574e992 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -124,13 +124,13 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
>  #define binder_debug(mask, x...) \
>  	do { \
>  		if (binder_debug_mask & mask) \
> -			printk(KERN_INFO x); \
> +			pr_info(x); \
>  	} while (0)
>  
>  #define binder_user_error(x...) \
>  	do { \
>  		if (binder_debug_mask & BINDER_DEBUG_USER_ERROR) \
> -			printk(KERN_INFO x); \
> +			pr_info(x); \
>  		if (binder_stop_on_user_error) \
>  			binder_stop_on_user_error = 2; \
>  	} while (0)
> @@ -418,7 +418,7 @@ repeat:
>  #if 1
>  	/* Sanity check */
>  	if (fdt->fd[fd] != NULL) {
> -		printk(KERN_WARNING "get_unused_fd: slot %d not NULL!\n", fd);
> +		pr_warn("get_unused_fd: slot %d not NULL!\n", fd);
>  		fdt->fd[fd] = NULL;
>  	}
>  #endif
> @@ -644,7 +644,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		goto free_range;
>  
>  	if (vma == NULL) {
> -		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> +		pr_err("binder: %d: binder_alloc_buf failed to "
>  		       "map pages in userspace, no vma\n", proc->pid);

Instead of using the "binder: " prefix here and there and now that you
have changed to pr_* functions, you can define the pr_fmt macro at the
beginning of the file (just before the #include sentences).

Regards,

Sam


