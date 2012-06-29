Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2F2HxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:53:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63484 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2F2HxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:53:01 -0400
Message-ID: <4FED5E51.4020707@tremplin-utc.net>
Date: Fri, 29 Jun 2012 09:50:41 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com, mjg@redhat.com,
        ike.pan@canonical.com, herton@canonical.com
Subject: Re: [PATCH 08/12] hp_accel: convert to module_acpi_driver()
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com> <1340881171-14811-9-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1340881171-14811-9-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-06-12 12:59, Mika Westerberg wrote:
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Hello,
Looks fine from my point of view.

Reviewed-by: Éric Piel <eric.piel@tremplin-utc.net>

Éric

> ---
>   drivers/platform/x86/hp_accel.c |   25 +------------------------
>   1 file changed, 1 insertion(+), 24 deletions(-)
>
> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
> index 22b2dfa..7246e66 100644
> --- a/drivers/platform/x86/hp_accel.c
> +++ b/drivers/platform/x86/hp_accel.c
> @@ -381,31 +381,8 @@ static struct acpi_driver lis3lv02d_driver = {
>   		.resume  = lis3lv02d_resume,
>   	}
>   };
> -
> -static int __init lis3lv02d_init_module(void)
> -{
> -	int ret;
> -
> -	if (acpi_disabled)
> -		return -ENODEV;
> -
> -	ret = acpi_bus_register_driver(&lis3lv02d_driver);
> -	if (ret < 0)
> -		return ret;
> -
> -	pr_info("driver loaded\n");
> -
> -	return 0;
> -}
> -
> -static void __exit lis3lv02d_exit_module(void)
> -{
> -	acpi_bus_unregister_driver(&lis3lv02d_driver);
> -}
> +module_acpi_driver(lis3lv02d_driver);
>
>   MODULE_DESCRIPTION("Glue between LIS3LV02Dx and HP ACPI BIOS and support for disk protection LED.");
>   MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
>   MODULE_LICENSE("GPL");
> -
> -module_init(lis3lv02d_init_module);
> -module_exit(lis3lv02d_exit_module);
>


