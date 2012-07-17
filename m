Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2GQQkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:40:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2GQQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:40:28 -0400
Date: Tue, 17 Jul 2012 09:40:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify the kobject_init function.
Message-ID: <20120717164024.GA7225@kroah.com>
References: <1342073375-27181-1-git-send-email-haodong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342073375-27181-1-git-send-email-haodong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 02:09:35PM +0800, Dong Hao wrote:
> The printk() function at the end of function kobject_init() already had '\n',
> so remove it.
> 
> While the kobject has been initialized, assign error string and
> jump to error case directly.
> 
> Signed-off-by: Dong Hao<haodong@linux.vnet.ibm.com>
> ---
>  lib/kobject.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 05de4dc..7b8a09c 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -278,14 +278,13 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
>  		goto error;
>  	}
>  	if (!ktype) {
> -		err_str = "must have a ktype to be initialized properly!\n";
> +		err_str = "must have a ktype to be initialized properly!";
>  		goto error;
>  	}
>  	if (kobj->state_initialized) {
> -		/* do not error out as sometimes we can recover */
> -		printk(KERN_ERR "kobject (%p): tried to init an initialized "
> -		       "object, something is seriously wrong.\n", kobj);
> -		dump_stack();
> +		err_str = "tried to init an initialized "
> +			"object, something is seriously wrong.";
> +		goto error;

You were already told why this patch is incorrect, why are you resending
it two more times?  That's a bit annoying and rude, don't you think?

Sorry, I can't take this, please read the code you are modifying.

greg k-h
