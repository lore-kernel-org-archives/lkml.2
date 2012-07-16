Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2GPXun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 19:50:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2GPXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 19:50:39 -0400
Date: Mon, 16 Jul 2012 16:50:34 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Fix kconfig dependencies
Message-ID: <20120716235034.GB11710@ubuntu-530U>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org
References: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:55:29AM -0500, Seth Forshee wrote:
> Fix the dependencies of apple-gmux to prevent it from being built-in
> when one or more of its dependencies is built as a module. Otherwise it
> can fail to build due to missing symbols.

Matthew: Are you okay with this, or is there some better way to do it?

I'm looking at Andreas's code for switcharoo support, and something I
want to do along with it is make apple-gmux not dependent on backlight
support (i.e. you can still build switcharoo support if
BACKLIGHT_CLASS_DEVICE is disabled). I'm assuming this patch as a
prerequisite. But things do get really monstrously ugly, so if there's a
cleaner way to enforce this that I haven't found I'd love to hear about
it.

Thanks,
Seth

> 
> Reported-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/platform/x86/Kconfig |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 2a262f5..cf65f0a 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -759,7 +759,9 @@ config SAMSUNG_Q10
>  config APPLE_GMUX
>  	tristate "Apple Gmux Driver"
>  	depends on PNP
> -	select BACKLIGHT_CLASS_DEVICE
> +	depends on BACKLIGHT_CLASS_DEVICE
> +	depends on BACKLIGHT_APPLE=n || BACKLIGHT_APPLE
> +	depends on ACPI_VIDEO=n || ACPI_VIDEO
>  	---help---
>  	  This driver provides support for the gmux device found on many
>  	  Apple laptops, which controls the display mux for the hybrid
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
