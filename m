Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2BEXXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 18:23:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40857 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2BEXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 18:23:19 -0500
Message-ID: <4F2F0F61.7070900@gmail.com>
Date: Mon, 06 Feb 2012 10:23:13 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/3] apple_bl: Convert printks to pr_<level>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com> <1328300884-21551-2-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1328300884-21551-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/12 07:28, Seth Forshee wrote:

> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/video/backlight/apple_bl.c |   29 ++++++++---------------------
>  1 files changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
> index be98d15..66d5bec 100644
> --- a/drivers/video/backlight/apple_bl.c
> +++ b/drivers/video/backlight/apple_bl.c
> @@ -16,6 +16,8 @@
>   *  get at the firmware code in order to figure out what it's actually doing.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -38,13 +40,6 @@ struct hw_data {
>  
>  static const struct hw_data *hw_data;
>  
> -#define DRIVER "apple_backlight: "
> -
> -/* Module parameters. */
> -static int debug;
> -module_param_named(debug, debug, int, 0644);
> -MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");


Removal of this module parameter is not noted in the changelog.

> -
>  /*
>   * Implementation for machines with Intel chipset.
>   */
> @@ -58,9 +53,7 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
>  {
>  	int intensity = bd->props.brightness;
>  
> -	if (debug)
> -		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
> -		       intensity);
> +	pr_debug("setting brightness to %d\n", intensity);


As Joe points out, this no longer has the same behaviour as it did
previously. The pr_debug will only show up if you have DEBUG defined.
Again, this should probably be mentioned in the changelog.

~Ryan
