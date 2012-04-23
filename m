Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2DWGRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:17:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36414 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752971Ab2DWGRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:17:03 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/WeB9OayLWYAZo2AKAMQsW8s5XsMP+dyV4NJT371
	l3ypJRiL0bxuIo
Message-ID: <4F94F3D7.5030904@gmx.de>
Date: Mon, 23 Apr 2012 06:16:55 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/2] video: msm: Fix section mismatches in mddi.c
References: <1334256334-8234-1-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1334256334-8234-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 06:45 PM, David Brown wrote:
> The change
>     commit 461cbe77d0a4f887c33a3a95ea68a7daf23b4302
>     Author: Gregory Bean <gbean@codeaurora.org>
>     Date:   Wed Jul 28 10:22:13 2010 -0700
> 
>         video: msm: Fix section mismatch in mddi.c.
> 
> fixes a section mismatch between the board file and the driver's probe
> function, however, it misses the additional mismatches between the
> probe function and some routines it calls.  Fix these up as well.
> 
> Signed-off-by: David Brown <davidb@codeaurora.org>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/msm/mddi.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
> index 4527cbf..b061d70 100644
> --- a/drivers/video/msm/mddi.c
> +++ b/drivers/video/msm/mddi.c
> @@ -420,7 +420,7 @@ static void mddi_resume(struct msm_mddi_client_data *cdata)
>  	mddi_set_auto_hibernate(&mddi->client_data, 1);
>  }
>  
> -static int __init mddi_get_client_caps(struct mddi_info *mddi)
> +static int __devinit mddi_get_client_caps(struct mddi_info *mddi)
>  {
>  	int i, j;
>  
> @@ -622,9 +622,9 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
>  
>  static struct mddi_info mddi_info[2];
>  
> -static int __init mddi_clk_setup(struct platform_device *pdev,
> -				 struct mddi_info *mddi,
> -				 unsigned long clk_rate)
> +static int __devinit mddi_clk_setup(struct platform_device *pdev,
> +				    struct mddi_info *mddi,
> +				    unsigned long clk_rate)
>  {
>  	int ret;
>  

