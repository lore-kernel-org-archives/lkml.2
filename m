Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2ILUHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:07:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45090 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751891Ab2ILUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:07:33 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1+jCOFkM5yj3EQ9rE4Q27BHQoERz8cs6uXqNQ4bnM
	8OAvV971oSf44E
From: Marc Dietrich <marvin24@gmx.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] staging: nvec: adjust for mfd_add_devices() API change
Date: Wed, 12 Sep 2012 22:07 +0200
Message-ID: <1378976.P27YKfEPUV@ax5200p>
User-Agent: KMail/4.8.4 (Linux/3.5.0-13-generic; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
References: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012 10:26:00 Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit 6607bad "mfd: core: Push irqdomain mapping out into devices"
> added a new parameter to mfd_add_devices(), but missed updating the
> nvec driver in staging.
> 
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Marc Dietrich <marvin24@gmx.de>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

wops, I somehow missed this one. Anyway, the patch looks fine.

Signed-off-by: Marc Dietrich <marvin24@gmx.de>

> --
> Samuel, I wonder if this patch should be squashed into the commit mentioned
> above in the MFD tree?
> ---
>  drivers/staging/nvec/nvec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index b0972d0..24d8eeb 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -837,7 +837,7 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) }
> 
>  	ret = mfd_add_devices(nvec->dev, -1, nvec_devices,
> -			      ARRAY_SIZE(nvec_devices), base, 0);
> +			      ARRAY_SIZE(nvec_devices), base, 0, NULL);
>  	if (ret)
>  		dev_err(nvec->dev, "error adding subdevices\n");
