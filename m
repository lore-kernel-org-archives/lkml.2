Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0GVXof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:44:35 -0400
Received: from kroah.org ([198.145.64.141]:41502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0GVXoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:44:30 -0400
Date: Thu, 22 Jul 2010 16:43:41 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/6] kobj: Fix memory leak on error path of
 kset_create_and_add
Message-ID: <20100722234341.GE674@kroah.com>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
 <1279836546-26913-7-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279836546-26913-7-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:09:06PM -0700, Patrick Pannuto wrote:
> This leak is the same as the bus path; kset->kobj.name is
> set, but kset_register fails, thus nothing will ever call
> kset_unregister and name will be leaked
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  lib/kobject.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index f07c572..713b235 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -843,6 +843,7 @@ struct kset *kset_create_and_add(const char *name,
>  		return NULL;
>  	error = kset_register(kset);
>  	if (error) {
> +		kfree(kset->kobj.name);

Again, we should be able to clean this up automatically better than
forcing this code to "know" that it has to handle this.

Any other ideas?

And are these error paths something that you have seen in a working
system?

thanks,

greg k-h
