Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2BUGlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:41:32 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23260 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2BUGlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:41:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="162555551"
Message-ID: <4F433C9A.5080503@codeaurora.org>
Date: Mon, 20 Feb 2012 22:41:30 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Clean up debugfs error handling a bit
References: <1329772500-20577-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1329772500-20577-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/2012 1:15 PM, Mark Brown wrote:
> Use IS_ERR_OR_NULL() rather than open coding it and ignore errors from
> failure to create the supply map.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>

>
> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>

>
> @@ -3231,14 +3231,13 @@ static int __init regulator_init(void)
>
>   #ifdef CONFIG_DEBUG_FS
>   	debugfs_root = debugfs_create_dir("regulator", NULL);
> -	if (IS_ERR(debugfs_root) || !debugfs_root) {
> +	if (IS_ERR_OR_NULL(debugfs_root)) {
>   		pr_warn("regulator: Failed to create debugfs directory\n");
>   		debugfs_root = NULL;
>   	}
>
> -	if (IS_ERR(debugfs_create_file("supply_map", 0444, debugfs_root,
> -				       NULL,&supply_map_fops)))
> -		pr_warn("regulator: Failed to create supplies debugfs\n");
> +	debugfs_create_file("supply_map", 0444, debugfs_root, NULL,
> +			&supply_map_fops);

Do you want an else here so that if the regulator directory fails we 
don't accidentally create a supply_map file in the root of debugfs? How 
ever unlikely that sounds.
