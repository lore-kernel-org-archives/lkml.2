Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1GHS6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:58:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1GHS6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:58:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [PATCH] runtime-pm: consistent utilization of deferred_resume
Date: Fri, 8 Jul 2011 20:59:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B59E040012A@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B59E040012A@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107082059.37210.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 08, 2011, Liu, ShuoX wrote:
> From 10bb3c851a0a9c9ca4d552743a371e3cfda81075 Mon Sep 17 00:00:00 2001
> From: ShuoX Liu <shuox.liu@intel.com>
> Date: Thu, 7 Jul 2011 15:59:06 +0800
> Subject: [PATCH] runtime-pm: consistent utilization of deferred_resume
> 
> dev->power.deferred_resume is used as a bool typically, so change
> one assignment to false from 0, like other places.
> 
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>

Applied to suspend-2.6/linux-next, will push for 3.1.

Thanks,
Rafael


> ---
>  drivers/base/power/runtime.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 0d4587b..af3d1a5 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -388,7 +388,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>  	retval = rpm_callback(callback, dev);
>  	if (retval) {
>  		__update_runtime_status(dev, RPM_ACTIVE);
> -		dev->power.deferred_resume = 0;
> +		dev->power.deferred_resume = false;
>  		if (retval == -EAGAIN || retval == -EBUSY)
>  			dev->power.runtime_error = 0;
>  		else
> 

