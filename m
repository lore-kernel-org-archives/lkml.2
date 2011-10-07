Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab1JGGvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:51:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56110 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab1JGGvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:51:21 -0400
X-Sasl-enc: vNr0ealBCC5+udxSgWUlrGXbEdLjVkYHtZ/Fr2zNMr54 1317970279
Date: Thu, 6 Oct 2011 23:43:49 -0700
From: Greg KH <greg@kroah.com>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] drivercore: add new error value for deferred probe
Message-ID: <20111007064349.GD27508@kroah.com>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-2-git-send-email-manjugk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317963790-29426-2-git-send-email-manjugk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:33:06AM +0500, G, Manjunath Kondaiah wrote:
> 
> Add new error value so that drivers can request deferred probe
> from drivercore.
> 
> Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
> Reported-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> Cc: linux-omap@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Cc: Dilan Lee <dilee@nvidia.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> 
>  include/linux/errno.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/errno.h b/include/linux/errno.h
> index 4668583..83d8fcf 100644
> --- a/include/linux/errno.h
> +++ b/include/linux/errno.h
> @@ -16,6 +16,7 @@
>  #define ERESTARTNOHAND	514	/* restart if no handler.. */
>  #define ENOIOCTLCMD	515	/* No ioctl command */
>  #define ERESTART_RESTARTBLOCK 516 /* restart by calling sys_restart_syscall */
> +#define EPROBE_DEFER	517	/* restart probe again after some time */

Can we really do this?  Isn't this some user/kernel api here?

What's wrong with just "overloading" on top of an existing error code?
Surely one of the other 516 types could be used here, right?

greg k-h
