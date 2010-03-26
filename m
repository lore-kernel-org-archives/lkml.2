Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0CZWcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:32:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab0CZWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:32:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH/RFC] platform_bus: Allow runtime PM by default
Date: Fri, 26 Mar 2010 23:35:06 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003262335.06941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 March 2010, Mark Brown wrote:
> Currently the default runtime PM callbacks for platform devices return
> -ENOSYS, preventing the use of runtime PM platforms until they have
> provided at least a default implementation. This hinders the use of
> runtime PM by devices which work with many platforms such as memory
> mapped devices, MFDs and on chip IPs shared by multiple architectures.
> 
> Change the default implementation to the standard pm_generic_runtime
> one, allowing drivers to use runtime PM without per-architecture
> changes.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Is it very urgent?

Rafael


> ---
> 
> I'm not 100% sure why the curret implementation returns -ENOSYS - I've
> got a horrible feeling I might be breaking something somewhere.
> 
>  drivers/base/platform.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 43479a9..eb0f8d9 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -967,17 +967,17 @@ static int platform_pm_restore_noirq(struct device *dev)
>  
>  int __weak platform_pm_runtime_suspend(struct device *dev)
>  {
> -	return -ENOSYS;
> +	return pm_generic_runtime_suspend(dev);
>  };
>  
>  int __weak platform_pm_runtime_resume(struct device *dev)
>  {
> -	return -ENOSYS;
> +	return pm_generic_runtime_resume(dev);
>  };
>  
>  int __weak platform_pm_runtime_idle(struct device *dev)
>  {
> -	return -ENOSYS;
> +	return pm_generic_runtime_idle(dev);
>  };
>  
>  #else /* !CONFIG_PM_RUNTIME */
> 

