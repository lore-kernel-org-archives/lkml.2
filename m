Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2HBUUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:20:35 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:52474 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753079Ab2HBUUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:20:34 -0400
Message-ID: <501AE0C9.1060402@xenotime.net>
Date: Thu, 02 Aug 2012 13:19:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Fix kconfig dependencies
References: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com> <1343927714-14937-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1343927714-14937-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 10:15 AM, Seth Forshee wrote:

> Fix the dependencies of apple-gmux to prevent it from being built-in
> when one or more of its dependencies is built as a module. Otherwise it
> can fail to build due to missing symbols.
> 
> v2: Add dependency on ACPI to fix build failure when ACPI=n
> 
> Reported-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/platform/x86/Kconfig |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 2a262f5..637074d 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -758,8 +758,11 @@ config SAMSUNG_Q10
>  
>  config APPLE_GMUX
>  	tristate "Apple Gmux Driver"
> +	depends on ACPI
>  	depends on PNP
> -	select BACKLIGHT_CLASS_DEVICE
> +	depends on BACKLIGHT_CLASS_DEVICE
> +	depends on BACKLIGHT_APPLE=n || BACKLIGHT_APPLE
> +	depends on ACPI_VIDEO=n || ACPI_VIDEO
>  	---help---
>  	  This driver provides support for the gmux device found on many
>  	  Apple laptops, which controls the display mux for the hybrid



-- 
~Randy
