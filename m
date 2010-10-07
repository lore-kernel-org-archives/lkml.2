Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0JGR4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:56:42 -0400
Received: from kroah.org ([198.145.64.141]:34013 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0JGR4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:56:15 -0400
Date: Thu, 7 Oct 2010 10:53:03 -0700
From: Greg KH <greg@kroah.com>
To: Roman Tereshonkov <roman.tereshonkov@nokia.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] kobject: name reference should not be lost when lack
 of memory error happens
Message-ID: <20101007175303.GB31639@kroah.com>
References: <1286447573-12579-1-git-send-email-roman.tereshonkov@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286447573-12579-1-git-send-email-roman.tereshonkov@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 01:32:53PM +0300, Roman Tereshonkov wrote:
> If lack of memory error happens we must restore the old kobject name reference

No, we can't do that, as the caller will not be expecting that to have
happened, right Kay?

I think the code as-is is correct, your kobject is in an unknown state
and can't be used anymore.

thanks,

greg k-h

> Signed-off-by: Roman Tereshonkov <roman.tereshonkov@nokia.com>
> ---
>  lib/kobject.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index f07c572..c5cb117 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  		return 0;
>  
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> -	if (!kobj->name)
> +	if (!kobj->name) {
> +		kobj->name = old_name;
>  		return -ENOMEM;
> +	}
>  
>  	/* ewww... some of these buggers have '/' in the name ... */
>  	while ((s = strchr(kobj->name, '/')))
> -- 
> 1.7.0.4
