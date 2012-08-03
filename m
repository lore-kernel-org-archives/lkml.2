Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2HCFHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:07:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40431 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2HCFHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:07:13 -0400
Date: Fri, 3 Aug 2012 00:07:06 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: manoj.iyer@canonical.com
cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, mjg@redhat.com,
        ibm-acpi@hmh.eng.br
Subject: Re: [PATCH] thinkpad-acpi: recognize latest V-Series using
 DMI_BIOS_VENDOR
In-Reply-To: <1343968187-20930-1-git-send-email-manoj.iyer@canonical.com>
Message-ID: <alpine.DEB.2.02.1208030005470.3041@lazy>
References: <1343968187-20930-1-git-send-email-manoj.iyer@canonical.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oops! This is embarrassing! my logic is flawed. Please ignore this patch, 
I will resend it

NACK


On Thu, 2 Aug 2012, manoj.iyer@canonical.com wrote:

> From: Manoj Iyer <manoj.iyer@canonical.com>
>
> In the latest V-series bios DMI_PRODUCT_VERSION does not contain
> the string Lenovo or Thinkpad, but is set to the model number, this
> causes the thinkpad_acpi module to fail to load. Recognize laptop
> as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.
>
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
> drivers/platform/x86/thinkpad_acpi.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index e7f7328..eec0b65 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -8657,7 +8657,8 @@ static int __must_check __init get_thinkpad_model_data(
> 		}
> 	}
>
> -	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
> +	s = dmi_get_system_info(DMI_PRODUCT_VERSION) ?
> +		dmi_get_system_info(DMI_BIOS_VENDOR) : NULL;
> 	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
> 		tp->model_str = kstrdup(s, GFP_KERNEL);
> 		if (!tp->model_str)
> -- 
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
