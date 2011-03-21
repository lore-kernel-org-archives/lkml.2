Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1CUUb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:31:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53589 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1CUUbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:31:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6292"; a="81030677"
Message-ID: <4D87B5BA.8030303@codeaurora.org>
Date: Mon, 21 Mar 2011 13:31:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Carl Vanderlip <carlv@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] video: msm: Set the EBI1 clock to 128MHz when performing
 blits
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org> <1300485562-27560-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1300485562-27560-1-git-send-email-carlv@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 02:59 PM, Carl Vanderlip wrote:
> diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
> index b03204d..0bb19fa 100644
> --- a/drivers/video/msm/mdp.c
> +++ b/drivers/video/msm/mdp.c
> @@ -656,6 +657,13 @@ int mdp_probe(struct platform_device *pdev)
>  		goto error_get_mdp_clk;
>  	}
>  
> +	mdp->ebi1_clk = clk_get(NULL, "ebi1_clk");

Please pass a device pointer as the first argument so we can match up
the ebi1_clk to the right device. MSM supports clkdev now so it's fairly
simple to do this.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

