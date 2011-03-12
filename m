Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1CLX3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 18:29:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab1CLX3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 18:29:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Green <andy@warmcat.com>
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform data to a dev path name
Date: Sun, 13 Mar 2011 00:29:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        patches@linaro.org, Andy Green <andy.green@linaro.org>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110312223212.27020.9839.stgit@otae.warmcat.com>
In-Reply-To: <20110312223212.27020.9839.stgit@otae.warmcat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103130029.38458.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, March 12, 2011, Andy Green wrote:
> This structure allows tagging arbitrary platform_data that can't be attached
> to a device until after it is probed, with the device path name that it is
> to be attached to.
> 
> Signed-off-by: Andy Green <andy.green@linaro.org>
> ---
> 
>  include/linux/platform_device.h |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 2e700ec..d8c0ba9 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -193,4 +193,21 @@ static inline char *early_platform_driver_setup_func(void)		\
>  }
>  #endif /* MODULE */
>  
> +/**
> + * platform_async_platform_data - maps a known bus + device name on to
> + *				  platform_data to be attached to that device
> + *				  when it is eventually instantiated.  For use
> + *				  with onboard devices on buses that probe
> + *				  asynchronously.  Device path fields must
> + *				  be separated with '/'.
> + * @device_path:	bus / device path, eg, "usb1/1-1/1-1.1"
> + * @platform_data:	platform_data to attach to device matching the
> + *			device_path
> + */
> +
> +struct platform_async_platform_data {
> +	const char *device_path;
> +	void *platform_data;
> +};
> +
>  #endif /* _PLATFORM_DEVICE_H_ */

Using device paths for this purpose seems to be very fragile to me.  Isn't
there any better solution?

Rafael
