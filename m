Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2CMMqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:46:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59097 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2CMMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:46:20 -0400
Message-ID: <4F5F4197.4070605@gmail.com>
Date: Tue, 13 Mar 2012 07:46:15 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH 1/1] of: add NULL parameter check for of_device_is_available
References: <1331638805-17136-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1331638805-17136-1-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 06:40 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This function will return 1 even the device node passed in
> is NULL which is a little error-prone.
> Change to return 0 if the device node passed in is NULL.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Applied.

Rob

> ---
>  drivers/of/base.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 133908a..b9347d8 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -280,6 +280,9 @@ int of_device_is_available(const struct device_node *device)
>  	const char *status;
>  	int statlen;
>  
> +	if (device == NULL)
> +		return 0;
> +
>  	status = of_get_property(device, "status", &statlen);
>  	if (status == NULL)
>  		return 1;

