Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2HDVup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 17:50:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42232 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2HDVuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 17:50:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.
Date: Sat, 4 Aug 2012 23:56:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1343918341-25985-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1343918341-25985-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208042356.35884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 02, 2012, Konrad Rzeszutek Wilk wrote:
> If the machine is booted without any cpu_idle driver set
> (b/c disable_cpuidle() has been called) we should follow
> other users of cpu_idle API and check the return value
> for NULL before using it.
> 
> Reported-by: Mark van Dijk <mark@internecto.net>
> Tested-by: Mark van Dijk <mark@internecto.net>
> Suggested-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/idle/intel_idle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index f559088..7383aa0 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -607,7 +607,7 @@ static int __init intel_idle_init(void)
>  	retval = cpuidle_register_driver(&intel_idle_driver);
>  	if (retval) {

What about:

  		struct cpuidle_driver *drv = cpuidle_get_driver();

  		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
			drv ? drv->name : "none");

>  		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
> -			cpuidle_get_driver()->name);
> +			cpuidle_get_driver() ? cpuidle_get_driver()->name : "none");
>  		return retval;
>  	}
>  
> 

Rafael
