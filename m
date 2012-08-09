Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2HIR5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:57:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48008 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2HIR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:57:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6798"; a="220780948"
Date: Thu, 9 Aug 2012 10:57:12 -0700
From: David Brown <davidb@codeaurora.org>
To: Damien Cassou <damien.cassou@lifl.fr>
Cc: kernel-janitors@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/video/msm/mddi_client_dummy.c: use devm_
 functions
Message-ID: <20120809175712.GA24215@codeaurora.org>
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
 <1344008414-2894-6-git-send-email-damien.cassou@lifl.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344008414-2894-6-git-send-email-damien.cassou@lifl.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:40:14PM +0200, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches. This patch replaces the use of kzalloc by devm_kzalloc.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
> 
> ---
>  drivers/video/msm/mddi_client_dummy.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/video/msm/mddi_client_dummy.c b/drivers/video/msm/mddi_client_dummy.c
> index d2a091c..4c31325 100644
> --- a/drivers/video/msm/mddi_client_dummy.c
> +++ b/drivers/video/msm/mddi_client_dummy.c
> @@ -51,7 +51,7 @@ static int mddi_dummy_probe(struct platform_device *pdev)
>  {
>  	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
>  	struct panel_info *panel =
> -		kzalloc(sizeof(struct panel_info), GFP_KERNEL);
> +		devm_kzalloc(&pdev->dev, sizeof(struct panel_info), GFP_KERNEL);
>  	int ret;
>  	if (!panel)
>  		return -ENOMEM;
> @@ -67,18 +67,11 @@ static int mddi_dummy_probe(struct platform_device *pdev)
>  				      client_data->fb_resource, 1);
>  	panel->panel_data.fb_data = client_data->private_client_data;
>  	panel->pdev.dev.platform_data = &panel->panel_data;
> -	ret = platform_device_register(&panel->pdev);
> -	if (ret) {
> -		kfree(panel);
> -		return ret;
> -	}
> -	return 0;
> +	return platform_device_register(&panel->pdev);

Removing this block causes a warning:
kernel/drivers/video/msm/mddi_client_dummy.c: In function 'mddi_dummy_probe':
kernel/drivers/video/msm/mddi_client_dummy.c:55:6: warning: unused variable 'ret' [-Wunused-variable]

Please remove the 'int ret;' line above as well.

Thanks,
David Brown

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
