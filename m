Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0E0FNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:13:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190Ab0E0FNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:13:33 -0400
Date: Wed, 26 May 2010 22:13:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-v2 2/8] cpuidle: add cpuidle_unregister_driver() error
 check
Message-Id: <20100526221301.5a85e3c5.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005270107360.4039@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	<56b9c89c17c1a85886f6d1928349e35bbb48c856.1274926772.git.len.brown@intel.com>
	<20100526201437.51f5c7f7.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1005270107360.4039@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 01:11:03 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> BUG_ON() cpuidle_unregister_driver() being called with
> a driver not matching the onee that successfully registered.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/cpuidle/driver.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 2257004..5b6fd0f 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -45,8 +45,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_driver);
>   */
>  void cpuidle_unregister_driver(struct cpuidle_driver *drv)
>  {
> -	if (!drv)
> -		return;
> +	BUG_ON(drv != cpuidle_curr_driver)
>  
>  	spin_lock(&cpuidle_driver_lock);
>  	cpuidle_curr_driver = NULL;

Actually, WARN_ON is nicer ;)   There's no point in killing the user's
machine over this recoverable error.

