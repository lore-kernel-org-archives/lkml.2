Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462Ab0J2HuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 03:50:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab0J2HuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 03:50:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: [PATCH] power: Fix typo in status comparison causing warning
Date: Fri, 29 Oct 2010 09:49:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <1288312192-28909-1-git-send-email-kjwinchester@gmail.com>
In-Reply-To: <1288312192-28909-1-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010290949.11833.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 29, 2010, Kevin Winchester wrote:
> GCC version 4.5.1 gives the following warning:
> 
> 	drivers/base/power/runtime.c: In function ‘rpm_check_suspend_allowed’:
> 	drivers/base/power/runtime.c:146:25: warning: comparison between ‘enum dpm_state’ and ‘enum rpm_status’
> 
> which seems to be a typo in that dev->power.runtime_status
> should be compared instead of dev->power.status.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  drivers/base/power/runtime.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 126ca49..02c652b 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -143,7 +143,7 @@ static int rpm_check_suspend_allowed(struct device *dev)
>  
>  	/* Pending resume requests take precedence over suspends. */
>  	else if ((dev->power.deferred_resume
> -			&& dev->power.status == RPM_SUSPENDING)
> +			&& dev->power.runtime_status == RPM_SUSPENDING)
>  	    || (dev->power.request_pending
>  			&& dev->power.request == RPM_REQ_RESUME))
>  		retval = -EAGAIN;

Ouch, this actually is a serious bug.

Thanks a lot for the fix, will push to Linus shortly.

Rafael

