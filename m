Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2AHKqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 05:46:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2AHKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 05:46:34 -0500
Date: Sun, 8 Jan 2012 11:46:30 +0100
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
Message-ID: <20120108104630.GA4354@ubuntu-mba>
Mail-Followup-To: Corentin Chary <corentincj@iksaif.net>,
	platform-driver-x86@vger.kernel.org,
	Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
	Andrzej Prochyra <andrzej@prochyra.name>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	David Herrmann <dh.herrmann@googlemail.com>,
	Richard =?utf-8?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
References: <20120105150832.GA25386@ubuntu-macmini>
 <1325945558-4661-1-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325945558-4661-1-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 03:12:38PM +0100, Corentin Chary wrote:
> On these laptops, the ACPI video is not functional, and very unlikely
> to be fixed by the vendor. Note that intel_backlight works for some
> of these laptops, and the backlight from samsung-laptop always work.
> 
> The good news is that newer laptops have functional ACPI video device
> and won't end up growing this list.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
> 
> Could the concerned people test this patch and check that it correctly
> disable the acpi_video backlight ?
> 
>  drivers/acpi/video_detect.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 45d8097..376bce2 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -132,6 +132,44 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK;
>  }
>  
> +/* Force to use vendor driver when the ACPI device is known to be
> + * buggy */
> +static int video_detect_force_vendor(const struct dmi_system_id *d)
> +{
> +	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
> +	return 0;
> +}
> +
> +static struct dmi_system_id video_detect_dmi_table[] = {
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "N150P",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
> +		DMI_MATCH(DMI_BOARD_NAME, "N150P"),
> +		},
> +	},
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "N145P/N250P/N260P",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
> +		DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
> +		},
> +	},
> +	{
> +	 .callback = video_detect_force_vendor,
> +	 .ident = "N150/N210/N220",
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
> +		DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
> +		},
> +	},
> +};
> +

I don't see NF110/NF210/NF310 in this list. Was that an oversight?
