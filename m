Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1LATzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:55:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1LATzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:55:49 -0500
Date: Thu, 1 Dec 2011 20:55:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Properly add the hid device
In-Reply-To: <1322671943-6788-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1112012055230.18207@pobox.suse.cz>
References: <1322671943-6788-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, K. Y. Srinivasan wrote:

> We need to properly add the hid device to correctly initialize the
> sysfs state. While this patch is against the staging tree; Jiri,
> please pick up this patch as you merge the Hyper-V mouse driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reported-by: Fuzhou Chen <fuzhouch@microsoft.com>
> ---
>  drivers/staging/hv/hv_mouse.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> index a28c549..66da8e3 100644
> --- a/drivers/staging/hv/hv_mouse.c
> +++ b/drivers/staging/hv/hv_mouse.c
> @@ -519,6 +519,10 @@ static int mousevsc_probe(struct hv_device *device,
>  
>  	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
>  
> +	ret = hid_add_device(hid_dev);
> +	if (ret)
> +		goto probe_err1;
> +
>  	ret = hid_parse_report(hid_dev, input_dev->report_desc,
>  				input_dev->report_desc_size);
>  

I have refreshed the patch to apply to drivers/hid/hid-hyperv.c driver and 
applied. Thanks,

-- 
Jiri Kosina
SUSE Labs
