Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1LAVtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:49:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38124 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab1LAVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:49:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Hibernate: Enable usermodehelpers in software_resume() error path
Date: Thu, 1 Dec 2011 22:52:47 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20111201154453.25828.85233.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111201154453.25828.85233.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112012252.47344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 01, 2011, Srivatsa S. Bhat wrote:
> In the software_resume() function defined in kernel/power/hibernate.c,
> if the call to create_basic_memory_bitmaps() fails, the usermodehelpers
> are not enabled (which had been disabled in the previous step). Fix it.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  kernel/power/hibernate.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index a6b0503..df35313 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -811,8 +811,10 @@ static int software_resume(void)
>  		goto close_finish;
>  
>  	error = create_basic_memory_bitmaps();
> -	if (error)
> +	if (error) {
> +		usermodehelper_enable();
>  		goto close_finish;
> +	}
>  
>  	pr_debug("PM: Preparing processes for restore.\n");
>  	error = prepare_processes();
> 
> 
> 

