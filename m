Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1LBTey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:34:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54913 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1LBTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:34:53 -0500
Date: Fri, 2 Dec 2011 20:34:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernate: Enable usermodehelpers in
	software_resume() error path
Message-ID: <20111202193452.GC31987@atrey.karlin.mff.cuni.cz>
References: <20111201154453.25828.85233.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201154453.25828.85233.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the software_resume() function defined in kernel/power/hibernate.c,
> if the call to create_basic_memory_bitmaps() fails, the usermodehelpers
> are not enabled (which had been disabled in the previous step). Fix it.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Ack.


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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
